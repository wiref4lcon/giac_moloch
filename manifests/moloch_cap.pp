node 
	'deb_moloch_cap_1',
	'deb_moloch_cap_2'
{

 #-Invoke the Docker module, this will install Docker and setup the environment for us
 include 'docker'

 #-Create the image "moloch_cap" from the .tgz file that holds Moloch's compiled binaries
 docker::image { 'moloch_cap':
   docker_file => '/moloch_cap/moloch_cap.tgz',
   subscribe   => File['/moloch_cap'],
 }

 #-Ensure configuration files are in place in "/etc/moloch_cap"
 file { '/etc/moloch_cap':
   ensure =>  present,
   source =>  'puppet:///modules/docker/moloch/cap_etc',
   recurse => true,
 }

 #-Ensure "moloch_cap" directory is in place
 file { '/moloch_cap':
   ensure  => present,
   source  => 'puppet:///modules/docker/moloch/moloch_cap',
   recurse => true,
 }

 #-Once the image has been created, run the "moloch_cap" container
 docker::run {'moloch_cap':
   image           => 'moloch_cap',
   ports           => ['8005:8005'],
   env		   => ['NODE_TLS_REJECT_UNAUTHORIZED=0'],
   privileged      => true,
   restart_service => true,
   volumes         => ['/etc/moloch_cap:/data/moloch/etc', '/var/moloch_cap:/data/moloch/raw'],
   net             => host,
  }
}
