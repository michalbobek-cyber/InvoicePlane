<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Register extends Base_Controller
{
    public function __construct()
    {
        parent::__construct();
$this->load->library('crypt');
        $this->load->model(['users/mdl_users', 'accounts/mdl_accounts', 'accounts/mdl_account_users']);
        $this->load->helper(['url', 'form']);
    }

    public function index()
    {
        $this->layout->buffer('content', 'register/form')->render();
    }

    public function submit()
    {
        $email = trim($this->input->post('email'));
        $pass  = $this->input->post('password');
        $name  = trim($this->input->post('name'));

        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->session->set_flashdata('alert_error', 'Zadejte platný e-mail.');
            redirect('register');
        }
        if (strlen($pass) < 8) {
            $this->session->set_flashdata('alert_error', 'Heslo musí mít alespoň 8 znaků.');
            redirect('register');
        }
        if (method_exists($this->mdl_users, 'email_exists') && $this->mdl_users->email_exists($email)) {
            $this->session->set_flashdata('alert_error', 'E-mail už je registrován.');
            redirect('register');
        }

        // Create user (adjust to your InvoicePlane user model)
        $password_hash = password_hash($pass, PASSWORD_DEFAULT);
        if (method_exists($this->mdl_users, 'create_minimal')) {
            $user_id = $this->mdl_users->create_minimal($email, $password_hash, $name);
        } else {
            // Fallback: generic insert (you may need to adapt column names)
$salt = $this->crypt->salt();
$hash = $this->crypt->generate_password($pass, $salt);

$this->db->insert('ip_users', [
    'user_email'        => $email,
    'user_password'     => $hash,
    'user_psalt'        => $salt,
    'user_name'         => $name,
    'user_active'       => 1,
    'user_type'         => 1, // admin/owner → dashboard
    'user_date_created' => date('Y-m-d H:i:s'),
    'user_date_modified'=> date('Y-m-d H:i:s')
]);
$user_id = (int)$this->db->insert_id();
        }

        // First account
        $acc_id = $this->mdl_accounts->create(['account_name' => $name ?: 'Můj účet']);
        $this->mdl_account_users->attach($acc_id, $user_id, 'owner');

        // login + set account
       // $this->session->set_userdata(['user_id' => $user_id, 'account_id' => $acc_id]);
        $this->session->set_userdata([
  'user_id'    => $user_id,
  'account_id' => $acc_id,
  'user_type'  => 1
]);
	$this->session->set_flashdata('alert_success', 'Registrace proběhla. Vítej!');
        redirect('dashboard');
    }
}
