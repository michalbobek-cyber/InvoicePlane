<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Mdl_accounts extends CI_Model
{
    protected $table = 'ip_accounts';

    public function create($data)
    {
        $this->db->insert($this->table, [
            'account_name' => $data['account_name'] ?? 'Můj účet',
        ]);
        return (int)$this->db->insert_id();
    }

    public function create_default_for_user($user_id, $name = null)
    {
        $acc_id = $this->create(['account_name' => $name ?: 'Můj účet']);
        $this->load->model('accounts/mdl_account_users');
        $this->mdl_account_users->attach($acc_id, $user_id, 'owner');
        return $acc_id;
    }
}
