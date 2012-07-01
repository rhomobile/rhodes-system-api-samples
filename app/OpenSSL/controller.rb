require 'rho/rhocontroller'
require 'openssl'
require 'openssl/digest'

class OpenSSLController < Rho::RhoController
  @layout = :simplelayout

  def index
    @openssl_test = ''

    cur_digest = OpenSSL::Digest::Digest.new('SHA1')
    @openssl_test << "OpenSSL::Digest::Digest.new('SHA1') = '" << cur_digest.to_s << "' (" << ((cur_digest.to_s.eql? "da39a3ee5e6b4b0d3255bfef95601890afd80709") ? 'OK':'FAILED' ) << ")<br/><br/>"

    render :back => '/app'
  end

end
