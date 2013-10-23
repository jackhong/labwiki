require 'warden-openid'
require 'openid/store/filesystem'

$users = {}

OPENID_FIELDS = {
    google: ["http://axschema.org/contact/email", "http://axschema.org/namePerson/last"],
      geni: ['http://geni.net/projects', 'http://geni.net/slices', 'http://geni.net/user/urn', 'http://geni.net/user/prettyname']
}

Warden::OpenID.configure do |config|
  config.required_fields = OPENID_FIELDS[:geni]
  config.user_finder do |response|
    $users[response.identity_url].nil? ? nil : response.identity_url
  end
end
