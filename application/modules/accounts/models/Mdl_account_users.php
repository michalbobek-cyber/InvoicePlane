<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Mdl_account_users extends CI_Model
{
    protected $table = 'ip_account_users';

    public function attach($account_id, $user_id, $role = 'member')
    {
        $this->db->replace($this->table, [
            'account_id' => (int)$account_id,
            'user_id'    => (int)$user_id,
            'role'       => $role
        ]);
        return true;
    }

    public function accounts_for_user($user_id)
    {
        return $this->db->select('a.account_id, a.account_name, au.role')
                        ->from('ip_accounts a')
                        ->join('ip_account_users au', 'au.account_id = a.account_id', 'inner')
                        ->where('au.user_id', (int)$user_id)
                        ->order_by('a.account_name', 'asc')
                        ->get()->result_array();
    }

    public function user_in_account($user_id, $account_id)
    {
        return (bool)$this->db->where('user_id', (int)$user_id)
                              ->where('account_id', (int)$account_id)
                              ->get($this->table)->row_array();
    }

    public function role($user_id, $account_id)
    {
        $row = $this->db->where('user_id', (int)$user_id)
                        ->where('account_id', (int)$account_id)
                        ->get($this->table)->row_array();
        return $row['role'] ?? null;
    }
}
