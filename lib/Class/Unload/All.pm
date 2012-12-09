package Class::Unload::All;

use strict;
use warnings;
use B::Hooks::EndOfScope qw/ on_scope_end /;
use Class::Unload;
use Module::Used qw/ modules_used_in_files /;

sub import {
	my $class = caller;
	my $path = _path($class);
	my @modules = modules_used_in_files($path);
	on_scope_end {
		for my $module (@modules) {
			Class::Unload->unload($module);
		}
	};
}

sub _path {
	my $class = shift;
	$class =~ s!::!/!g;
	$class .= '.pm';
	return $INC{$class};
}

1;
