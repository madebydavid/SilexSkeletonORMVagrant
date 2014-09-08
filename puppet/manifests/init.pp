
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

class silex-server {

    # required base packages    
    exec { 'apt-get update':
        command => 'apt-get update',
    }
    
    $silexPackages = [
        'lamp-server^',
        'php5-curl',
        'curl',
        'vim',
        'php5-intl',
    ]
    package { 
        $silexPackages:
            ensure => 'installed',
            require => Exec['apt-get update'],
    }

    # install composer project
    composer::project { 'SilexSkeletonORM':
        project_name    => 'madebydavid/silex-skeleton-orm',
        target_dir      => '/vagrant/www',
        version         => '2.0',
        prefer_source   => true,
        stability       => 'dev',
        keep_vcs        => false,
        dev             => true,
    }

    exec {'apache restart':
        command         => '/etc/init.d/apache2 restart',
        require         => [ Package['lamp-server^'], Exec['apache enable modules'] ],
    }
  
    file { '/etc/apache2/httpd.conf':
        ensure          => file,
        mode            => 644
    }
    service { 'apache2':
        ensure          => running,
        enable          => true,
        subscribe       => File['/etc/apache2/httpd.conf'],
        require         => Package['lamp-server^'],
    }
    file_line { 'EnableSendfile off':
        ensure          => present,
        line            => 'EnableSendfile off',
        path            => '/etc/apache2/httpd.conf',
        require         => Package['lamp-server^'],
    }
   
    file { '/var/www':
        ensure          => 'link',
        owner           => "vagrant",
        group           => "vagrant",
        mode            => 777,
        target          => '/vagrant/www/web',
        require         => Package['lamp-server^'],
    }
 
    file { '/etc/apache2/sites-enabled/000-default':
        ensure          => file,
        source          => 'puppet:///conf/apache/000-default',
        require         => Package['lamp-server^'],
    }
    
    exec { 'apache enable modules':
        command         => 'a2enmod rewrite',
        require         => Package['lamp-server^'],
    }

    
}
 
include silex-server
include composer



