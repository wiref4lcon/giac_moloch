node 'deb_moloch_es' {

 #-Invoke the Docker module, this will install Docker and setup the environment for us
 include 'docker'

 #-Create the image "moloch_es" from the .tgz file that holds Moloch's compiled binaries
 docker::image { 'moloch_es':
   docker_file => '/moloch_es/moloch_es.tgz',
   subscribe   => File['/moloch_es'],
 }

 #-Ensure configuration files are in place in "/etc/moloch_es"
 file { '/etc/moloch_es':
   ensure =>  present,
   source =>  'puppet:///modules/docker/moloch/es_etc',
   recurse => true,
 }
 
 #-Ensure directory "moloch_es" is in place
 file { '/moloch_es':
   ensure  => present,
   source  => 'puppet:///modules/docker/moloch/moloch_es',
   recurse => true,
 }

 #-Once the image has been created, run the "moloch_es" container
 docker::run {'moloch_es':
   image           => 'moloch_es',
   ports           => ['9200:9200', '9300:9300'],
   #env            => ['NODE_TLS_REJECT_UNAUTHORIZED=0'],
   hostname        => 'moloch_es',
   restart_service => true,
   volumes         => ['/etc/moloch_es:/data/moloch/etc', '/var/moloch_es:/data/moloch/data', '/etc/hosts:/etc/hosts'],
   net             => bridge,
  }

#################################################################################################################################
#Viewer - Section-############################################################################################################### 

 #-Create the image "moloch_viewer" from the .tgz file that holds Moloch's compiled binaries
 docker::image { 'moloch_viewer':
   docker_file => '/moloch_viewer/moloch_viewer.tgz',
   subscribe   => File['/moloch_viewer'],
 }

 #-Ensure configuration files are in place in "/etc/moloch_cap"
 file { '/etc/moloch_viewer':
   ensure =>  present,
   source =>  'puppet:///modules/docker/moloch/viewer_etc',
   recurse => true,
 }

 #-Ensure "moloch_viewer" directory is in place
 file { '/moloch_viewer':
   ensure  => present,
   source  => 'puppet:///modules/docker/moloch/moloch_viewer',
   recurse => true,
 }

 #-Once the image has been created, run the "moloch_viewer" container
 docker::run {'moloch_viewer':
   image           => 'moloch_viewer',
   ports           => ['8005:8005'],
   env             => ['NODE_TLS_REJECT_UNAUTHORIZED=0'],
   restart_service => true,
   volumes         => ['/etc/moloch_viewer:/data/moloch/etc'],
   net             => host,
  }
}
