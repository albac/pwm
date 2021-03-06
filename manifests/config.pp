#
# == Class: pwm::config
#
# Configure pwm
#
class pwm::config
(
    $dirsrv_type

) inherits pwm::params
{

    include tomcat::params

    # Allow pwm to write to the webapp directories it needs
    file { 'pwm-WEB-INF':
        ensure => directory,
        name => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF",
        owner => "${::tomcat::params::user}",
        group => "${::tomcat::params::group}",
        mode => 755,
        require => Class['pwm::install'],
    }

    file { 'pwm-logs':
        ensure => directory,
        name => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF/logs",
        owner => "${::tomcat::params::user}",
        group => "${::tomcat::params::group}",
        mode => 755,
        require => Class['pwm::install'],
    }

    file { 'pwm-LocalDB':
        ensure => directory,
        name => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF/LocalDB",
        owner => "${::tomcat::params::user}",
        group => "${::tomcat::params::group}",
        mode => 755,
        require => Class['pwm::install'],
    }

    # Pwm webapp configuration
    file { 'pwm-PwmConfiguration.xml':
        ensure => present,
        name => "${::tomcat::params::autodeploy_dir}/pwm/WEB-INF/PwmConfiguration.xml",
        source => "puppet:///files/PwmConfiguration.xml",
        owner => "${::tomcat::params::user}",
        group => "${::tomcat::params::group}",
        mode => 644,
        require => Class['pwm::install'],
    }
    

    # Tomcat configuration
    include pwm::config::tomcat

    # Directory service-specific configuration
    case $dirsrv_type {
        '389ds': {
            include pwm::config::dirsrv
        }
        'none': {
            # Do nothing
        }
        default: { fail("Invalid value ${dirsrv_type} for parameter \$dirsrv_type") }
    }
}
