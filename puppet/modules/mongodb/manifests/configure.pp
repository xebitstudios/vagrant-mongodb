define mongodb::configure (
    $replSet    = $title,
    $arbiter    = 'false',
    $useauth    = 'false',
    $rest       = '',
    $prealloc = '',
    $journal  = '',
    $port       = '27017',
    $rest       = false,
) {

    include mongodb

    if ($arbiter == 'true') {
        if ($journal == '') {
            $nojournal = 'true'
        }
        if ($noprealloc == '') {
            $noprealloc = 'true'
        }
    } else {
        if ($journal == '') {
            $nojournal = 'false'
        }
        if ($prealloc == '') {
            $noprealloc = 'false'
        }
    }

    if ($useauth == 'false'){
        $auth = 'false'
    } else {
        $auth = 'true'
        if ($replSet != '') {
            $keyFile = "/etc/mongodb.key"
        }
    }

    file { '/etc/mongodb.key':
        content => template('mongodb/mongodb.key.erb'),
        mode => '0600',
        owner => 'mongodb',
        notify => Service['mongodb'],
        require => Package['mongodb-10gen'],
    }
    file { '/etc/mongodb.conf':
        content => template('mongodb/mongodb.conf.erb'),
        mode => '0644',
        notify => Service['mongodb'],
        require => Package['mongodb-10gen'],
    }
    file { '/etc/default/mongodb':
        content => template('mongodb/mongodb.upstart.default.erb'),
        mode => '0644',
        notify => Service['mongodb'],
        require => Package['mongodb-10gen'],
    }
    file { '/etc/init/mongodb.conf':
        content => template('mongodb/mongodb.upstart.conf.erb'),
        mode => '0644',
        notify => Service['mongodb'],
        require => Package['mongodb-10gen'],
    }
}
