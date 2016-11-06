# All znc parameters should be defined through hiera
include ::znc
$userid = hiera('userid')
::znc::user { $userid:
  buffer   => hiera('userbuffer'),
  realname => hiera('username'),
  pass     => hiera('userpass'),
}

include ::ntp

class { '::firewall': }
resources { "firewall": purge => true }
firewall { '01 ping':
  proto  => 'icmp',
  icmp   => 8,
  state  => 'NEW',
  action => 'accept',
}->
firewall { '02 lo interface':
  proto   => 'all',
  iniface => 'lo',
  action  => 'accept',
}->
firewall { '03 related established rules':
  proto   => 'all',
  state   => ['RELATED', 'ESTABLISHED'],
  action  => 'accept',
}->
firewall { '50 ssh':
  dport   => 22,
  proto  => tcp,
  action => accept,
}->
firewall { '100 znc':
  dport  => hiera('znc::port'),
  proto  => tcp,
  action => accept,
}->
firewall { '999 drop all':
  proto   => 'all',
  action  => 'drop',
  before  => undef,
}
