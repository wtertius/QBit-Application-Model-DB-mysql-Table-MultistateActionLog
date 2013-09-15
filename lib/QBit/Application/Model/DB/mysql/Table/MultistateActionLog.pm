package QBit::Application::Model::DB::mysql::Table::MultistateActionLog;

use qbit;

use base qw(QBit::Application::Model::DB::mysql::Table);

sub default_fields {
    my ($package, %opts) = @_;

    return (
        {name => 'id', type => 'BIGINT',   unsigned => TRUE, not_null => TRUE, autoincrement => TRUE},
        {name => 'dt', type => 'DATETIME', not_null => TRUE},
        {name => 'user_id'},
        (map {{name => "elem_$_", not_null => TRUE}} @{$opts{'elem_table_pk'}}),
        {name => 'old_multistate', type => 'BIGINT',  unsigned => TRUE, not_null => TRUE},
        {name => 'action',         type => 'VARCHAR', length   => 100,  not_null => TRUE},
        {name => 'new_multistate', type => 'BIGINT',  unsigned => TRUE, not_null => TRUE},
        ($opts{'with_opts'} ? {name => 'opts', type => 'TEXT', not_null => TRUE} : ()),
        {name => 'comment', type => 'VARCHAR', length => 100, not_null => TRUE, default => ''},
    );
}

sub default_primary_key {
    return ['id'];
}

sub default_indexes {
    my ($package, %opts) = @_;
    my @elems = $opts{'elem_table_pk'} ? map("elem_$_", @{$opts{'elem_table_pk'}}) : 'elem_id';
    return ({fields => ['dt', @elems, 'action']}, {fields => [@elems, 'action']});
}

sub default_foreign_keys {
    my ($package, %opts) = @_;

    return (
        [['user_id'] => users => ['id']],
        [[map {"elem_$_"} @{$opts{'elem_table_pk'}}] => $opts{'elem_table'} => $opts{'elem_table_pk'}],
    );
}

TRUE;
