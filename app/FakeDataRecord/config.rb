require 'rho'
require File.join(__rhoGetCurrentDir(), 'apps','app','config/environment')

Rho::RhoConfig::add_source("FakeDataRecord", {"url"=>"", "source_id"=>1230})