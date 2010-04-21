require 'rho'

image_schema = {
    'columns' =>['image_uri']
}

Rho::RhoConfig::add_source("Image", {'url' =>'Image', 'blob_attribs'=>['image_uri'], 'schema_version' => '1.0', "schema" => nil })