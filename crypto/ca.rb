#!/bin/env ruby
require 'openssl'

# CA private/public key pairs
ca_key = OpenSSL::PKey::RSA.new(2048)

# Define the legitimate CA which signs the legit certificate
ca_cert = OpenSSL::X509::Certificate.new
ca_cert.serial = 1
ca_cert.subject = OpenSSL::X509::Name.parse("/DC=os/DC=nach/CN=Nach.os CA")
ca_cert.issuer = ca_cert.subject
ca_cert.public_key = ca_key.public_key
ca_cert.not_before = Time.now
ca_cert.not_after = ca_cert.not_before + 365 * 24 * 60 * 60 # 1 year validity

# What makes a CA a CA...
ca_extensions = OpenSSL::X509::ExtensionFactory.new
ca_extensions.subject_certificate = ca_cert
ca_extensions.issuer_certificate = ca_cert
ca_cert.add_extension(ca_extensions.create_extension("basicConstraints","CA:TRUE",true))
ca_cert.add_extension(ca_extensions.create_extension("keyUsage","keyCertSign, cRLSign", true))
ca_cert.add_extension(ca_extensions.create_extension("subjectKeyIdentifier","hash",false))
ca_cert.add_extension(ca_extensions.create_extension("authorityKeyIdentifier","keyid:always",false))

# CA signs itself. It'll be fine. Trust it.
ca_cert.sign(ca_key, OpenSSL::Digest::SHA256.new)
begin
    Dir.mkdir('ca', 0755)
rescue Errno::EEXIST
end
open 'ca/privkey.pem', 'w' do |io| io.write(ca_key.to_pem) end
open 'ca/pubkey.pem', 'w' do |io| io.write(ca_key.public_key.to_pem) end
open 'ca/cert.pem', 'w' do |io| io.write(ca_cert.to_pem) end

target_servername = OpenSSL::X509::Name.parse('CN=legit.nach.os')

legit_key = OpenSSL::PKey::RSA.new(2048)
legit_cert = OpenSSL::X509::Certificate.new
legit_cert.version = 2
legit_cert.serial = 101
legit_cert.subject = target_servername
legit_cert.issuer = ca_cert.subject
legit_cert.public_key = legit_key.public_key
legit_cert.not_before = Time.now
legit_cert.not_after = legit_cert.not_before + 365 * 24 * 60 * 60 # 1 year validity

legit_extensions = OpenSSL::X509::ExtensionFactory.new
legit_extensions.subject_certificate = legit_cert
legit_cert.add_extension(legit_extensions.create_extension("keyUsage","digitalSignature", true))
legit_cert.add_extension(legit_extensions.create_extension("subjectKeyIdentifier","hash",false))

legit_cert.sign(ca_key, OpenSSL::Digest::SHA256.new)
begin
    Dir.mkdir('legit', 0755)
rescue Errno::EEXIST
end
open 'legit/privkey.pem', 'w' do |io| io.write(legit_key.to_pem) end
open 'legit/pubkey.pem', 'w' do |io| io.write(legit_key.public_key.to_pem) end
open 'legit/cert.pem', 'w' do |io| io.write(legit_cert.to_pem) end

# Badguy makes up its own certificate
badguy_key = OpenSSL::PKey::RSA.new(2048)
badguy_cert = OpenSSL::X509::Certificate.new
badguy_cert.public_key = badguy_key.public_key
badguy_cert.version = 2
badguy_cert.serial = 901 
badguy_cert.not_before = Time.now
badguy_cert.not_after = badguy_cert.not_before + 365 * 24 * 60 * 60 # 1 year validity
badguy_cert.subject = target_servername

badguy_cert.sign(badguy_key, OpenSSL::Digest::SHA256.new)
begin
    Dir.mkdir('badguy', 0755)
rescue Errno::EEXIST
end
open 'badguy/privkey.pem', 'w' do |io| io.write(badguy_key.to_pem) end
open 'badguy/pubkey.pem', 'w' do |io| io.write(badguy_key.public_key.to_pem) end
open 'badguy/cert.pem', 'w' do |io| io.write(badguy_cert.to_pem) end

