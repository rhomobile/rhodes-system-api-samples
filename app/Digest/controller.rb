require 'rho/rhocontroller'
require 'digest'
require 'digest/md5'
require 'digest/sha1'

class DigestController < Rho::RhoController
  @layout = :simplelayout

  def index
    @digest_test = ''

    @digest_test << "Digest.hexencode('') = #{Digest.hexencode('').inspect}<br/>"

    string   = 'sample string'
    encoded  = "73616d706c6520737472696e67"
    hestring = Digest.hexencode(string)
    @digest_test << "Digest.hexencode('#{string}') = #{hestring.inspect} (#{ (hestring.eql? encoded) ? 'OK':'FAILED' })<br/><br/>"

    cont = "Ipsum is simply dummy text of the printing and typesetting industry. \nLorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. \nIt has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. \nIt was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
    sha1 = "X!\255b\323\035\352\314a|q\344+\376\317\361V9\324\343".force_encoding('BINARY')
    our_sha1 = Digest::SHA1.digest(cont)
    @digest_test << "SHA1('Lorem Ipsum ...') = #{our_sha1.inspect} (#{ (our_sha1.eql? sha1) ? 'OK':'FAILED' })<br/><br/>"

    md5 = "\2473\267qw\276\364\343\345\320\304\350\313\314\217n".force_encoding('BINARY')
    md5hex = "a733b77177bef4e3e5d0c4e8cbcc8f6e"
    our_md5 = Digest::MD5.digest(cont)
    our_md5hex = Digest.hexencode(our_md5)
    @digest_test << "MD5('Lorem Ipsum ...') = #{our_md5.inspect} (#{ (our_md5.eql? md5) ? 'OK':'FAILED' })"
    @digest_test << " = #{our_md5hex.inspect} (#{ (our_md5hex.eql? md5hex) ? 'OK':'FAILED' })<br/><br/>"

    render :back => '/app'
  end

end
