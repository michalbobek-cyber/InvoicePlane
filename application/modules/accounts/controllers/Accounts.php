<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Accounts extends Base_Controller
{
    public function __construct()
    {
        parent::__construct();
        $this->load->model(['accounts/mdl_accounts', 'accounts/mdl_account_users']);
        if (!$this->session->userdata('user_id')) {
            redirect('sessions/login');
        }
    }

    public function index()
    {
        $user_id = (int)$this->session->userdata('user_id');
        $data['accounts'] = $this->mdl_account_users->accounts_for_user($user_id);
        $this->layout->set('active_tab', 'accounts');
        $this->layout->buffer('content', 'accounts/list', $data)->render();
    }

    public function switch($account_id = 0)
    {
        $account_id = (int)$account_id;
        if ($account_id <= 0) { show_error('Invalid account id', 400); }
        $user_id = (int)$this->session->userdata('user_id');
        if ($this->mdl_account_users->user_in_account($user_id, $account_id)) {
            $this->session->set_userdata('account_id', $account_id);
            $this->session->set_flashdata('alert_success', 'Účet byl přepnut.');
            redirect('dashboard');
        }
        show_error('Nemáte přístup k tomuto účtu.', 403);
    }
}
