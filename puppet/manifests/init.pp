
Exec { path => [ '/bin/', '/sbin/' , '/usr/bin/', '/usr/sbin/' ] }

class { 'composer': 
    suhosin_enabled => false,
}

class silex-server {

    # required base packages    
    exec { 'apt-get update':
        command => 'apt-get update',
    }
    
    $silexPackages = [
        'lamp-server^',
        'php5-curl',
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
        prefer_dist     => true,
        stability       => 'dev',
        keep_vcs        => false,
        dev             => true,
        timeout         => 0,
        require         => Package['lamp-server^'],
    }

    file { '/var/www':
        ensure          => 'link',
        owner           => "vagrant",
        group           => "vagrant",
        mode            => 777,
        target          => '/vagrant/www/web',
        force           => true,
        require         => Package['lamp-server^'],
    }
 
    file { '/etc/apache2/sites-available/000-default.conf':
        ensure          => file,
        source          => 'puppet:///modules/apache/000-default.conf',
        require         => Package['lamp-server^'],
    }

    file { '/etc/apache2/sites-enabled/000-default.conf':
        ensure          => 'link',
        source          => '/etc/apache2/sites-available/000-default.conf',
        require         => [ Package['lamp-server^'], File['/etc/apache2/sites-available/000-default.conf'] ],
    }

    file { '/etc/apache2/conf-available/disable-send-file.conf':
        ensure          => file,
        source          => 'puppet:///modules/apache/disable-send-file.conf',
        require         => Package['lamp-server^'],
    }

    file { '/etc/apache2/conf-enabled/disable-send-file.conf':
        ensure          => 'link',
        target          => '/etc/apache2/conf-available/disable-send-file.conf',
        force           => true,
        require         => File['/etc/apache2/conf-available/disable-send-file.conf'],
    }
    
    exec { 'make apache ssl dir':
        command         => 'mkdir /etc/apache2/ssl',
        require         => Package['lamp-server^']
    }

    file { '/etc/apache2/ssl/apache.crt':
        ensure          => file,
        source          => 'puppet:///modules/apache/ssl/apache.crt',
        require         => Exec['make apache ssl dir'],
    }

    file { '/etc/apache2/ssl/apache.key':
        ensure          => file,
        source          => 'puppet:///modules/apache/ssl/apache.key',
        require         => Exec['make apache ssl dir'],
    }

    exec { 'apache enable modules':
        command         => 'a2enmod rewrite ssl',
        require         => Package['lamp-server^'],
    }

    exec {'apache restart':
        command         => '/etc/init.d/apache2 restart',
        require         => [ 
                                Package['lamp-server^'], 
                                Exec['apache enable modules'],
                                File['/etc/apache2/sites-enabled/000-default.conf'],
                                File['/etc/apache2/conf-enabled/disable-send-file.conf']
                           ],
    }
    
}
 
include silex-server
include composer



