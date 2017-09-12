#!/bin/env ruby
require 'openssl'

# Dir for results
begin
    Dir.mkdir('ssl', 0755)
rescue Errno::EEXIST
end

# CA private/public key pairs
ca_key = OpenSSL::PKey::RSA.new(2048)

# Define the legitimate CA which signs the legit certificate
ca_cert = OpenSSL::X509::Certificate.new
ca_cert.version = 2
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
ca_cert.add_extension(ca_extensions.create_extension("subjectKeyIdentifier", "hash", false))
ca_cert.add_extension(ca_extensions.create_extension("authorityKeyIdentifier", "keyid:always", false))

# CA signs itself. It'll be fine. Trust it.
ca_cert.sign(ca_key, OpenSSL::Digest::SHA256.new)
begin
    Dir.mkdir('ssl/ca', 0755)
rescue Errno::EEXIST
end
open 'ssl/ca/privkey.pem', 'w' do |io| io.write(ca_key.to_pem) end
open 'ssl/ca/pubkey.pem', 'w' do |io| io.write(ca_key.public_key.to_pem) end
open 'ssl/ca/cert.pem', 'w' do |io| io.write(ca_cert.to_pem) end

target_servername = OpenSSL::X509::Name.parse('CN=legit.nach.os')
target_domains = ['legit.nach.os']
target_sans = target_domains.map { |domain| "DNS:#{domain}" }.join(',')

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
legit_cert.add_extension(legit_extensions.create_extension('subjectAltName', target_sans))
legit_cert.add_extension(legit_extensions.create_extension("keyUsage","digitalSignature", true))
legit_cert.add_extension(legit_extensions.create_extension("subjectKeyIdentifier", "hash", false))

legit_cert.sign(ca_key, OpenSSL::Digest::SHA256.new)
begin
    Dir.mkdir('ssl/legit', 0755)
rescue Errno::EEXIST
end
open 'ssl/legit/privkey.pem', 'w' do |io| io.write(legit_key.to_pem) end
open 'ssl/legit/pubkey.pem', 'w' do |io| io.write(legit_key.public_key.to_pem) end
open 'ssl/legit/cert.pem', 'w' do |io| io.write(legit_cert.to_pem) end

# Badguy makes up its own certificate
evil_key = OpenSSL::PKey::RSA.new(2048)
evil_cert = OpenSSL::X509::Certificate.new
evil_cert.public_key = evil_key.public_key
evil_cert.version = 2
evil_cert.serial = 901 
evil_cert.not_before = Time.now
evil_cert.not_after = evil_cert.not_before + 365 * 24 * 60 * 60 # 1 year validity
evil_cert.subject = target_servername

evil_extensions = OpenSSL::X509::ExtensionFactory.new
evil_extensions.subject_certificate = evil_cert
evil_cert.add_extension(evil_extensions.create_extension('subjectAltName', target_sans))
evil_cert.add_extension(evil_extensions.create_extension("keyUsage","digitalSignature", true))
evil_cert.add_extension(evil_extensions.create_extension("subjectKeyIdentifier", "hash", false))

evil_cert.sign(evil_key, OpenSSL::Digest::SHA256.new)
begin
    Dir.mkdir('ssl/evil', 0755)
rescue Errno::EEXIST
end
open 'ssl/evil/privkey.pem', 'w' do |io| io.write(evil_key.to_pem) end
open 'ssl/evil/pubkey.pem', 'w' do |io| io.write(evil_key.public_key.to_pem) end
open 'ssl/evil/cert.pem', 'w' do |io| io.write(evil_cert.to_pem) end

