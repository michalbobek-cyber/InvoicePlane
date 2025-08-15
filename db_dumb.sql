-- phpMyAdmin SQL Dump
-- version 3.5.FORPSI
-- http://www.phpmyadmin.net
--
-- Počítač: 185.129.138.45
-- Vygenerováno: Pát 15. srp 2025, 02:13
-- Verze MySQL: 8.0.26-16
-- Verze PHP: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Databáze: `f181241`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`f181241`@`%` PROCEDURE `add_col_if_missing`(IN p_table VARCHAR(64), IN p_col VARCHAR(64), IN p_tail VARCHAR(255))
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = p_table AND COLUMN_NAME = p_col
  ) THEN
    SET @s = CONCAT('ALTER TABLE ', p_table, ' ADD COLUMN ', p_col, ' ', p_tail);
    PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
  END IF;
END$$

CREATE DEFINER=`f181241`@`%` PROCEDURE `add_fk_if_missing`(IN p_table VARCHAR(64), IN p_fkname VARCHAR(64), IN p_col VARCHAR(64))
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.REFERENTIAL_CONSTRAINTS
    WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = p_fkname
  ) THEN
    SET @s = CONCAT('ALTER TABLE ', p_table, ' ADD CONSTRAINT ', p_fkname,
                    ' FOREIGN KEY (', p_col, ') REFERENCES ip_accounts(account_id) ON DELETE CASCADE');
    PREPARE st FROM @s; EXECUTE st; DEALLOCATE PREPARE st;
  END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_accounts`
--

CREATE TABLE IF NOT EXISTS `ip_accounts` (
  `account_id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `account_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Vypisuji data pro tabulku `ip_accounts`
--

INSERT INTO `ip_accounts` (`account_id`, `account_name`, `created_at`) VALUES
(1, 'Default', '2025-08-14 06:51:57'),
(6, 'Michal Bobek', '2025-08-14 07:47:15'),
(7, 'Michal Bobek', '2025-08-14 07:48:16'),
(8, 'Michal Bobek', '2025-08-14 08:12:06'),
(9, 'Michal Bobek', '2025-08-14 18:44:44'),
(10, 'Michal Bobek', '2025-08-14 23:31:43');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_account_users`
--

CREATE TABLE IF NOT EXISTS `ip_account_users` (
  `account_id` bigint unsigned NOT NULL,
  `user_id` int NOT NULL,
  `role` enum('owner','admin','member','viewer') NOT NULL DEFAULT 'owner',
  PRIMARY KEY (`account_id`,`user_id`),
  KEY `fk_au_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Vypisuji data pro tabulku `ip_account_users`
--

INSERT INTO `ip_account_users` (`account_id`, `user_id`, `role`) VALUES
(1, 1, 'owner'),
(10, 8, 'owner');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_clients`
--

CREATE TABLE IF NOT EXISTS `ip_clients` (
  `client_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `client_date_created` datetime NOT NULL,
  `client_date_modified` datetime NOT NULL,
  `client_name` text,
  `client_address_1` text,
  `client_address_2` text,
  `client_city` text,
  `client_state` text,
  `client_zip` text,
  `client_country` text,
  `client_phone` text,
  `client_fax` text,
  `client_mobile` text,
  `client_email` text,
  `client_web` text,
  `client_vat_id` text,
  `client_tax_code` text,
  `client_language` varchar(255) DEFAULT 'system',
  `client_active` int NOT NULL DEFAULT '1',
  `client_surname` varchar(255) DEFAULT NULL,
  `client_title` varchar(50) DEFAULT NULL,
  `client_avs` varchar(16) DEFAULT NULL,
  `client_insurednumber` varchar(30) DEFAULT NULL,
  `client_veka` varchar(30) DEFAULT NULL,
  `client_birthdate` date DEFAULT NULL,
  `client_gender` int DEFAULT '0',
  PRIMARY KEY (`client_id`),
  KEY `client_active` (`client_active`),
  KEY `idx_clients_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=3 ;

--
-- Vypisuji data pro tabulku `ip_clients`
--

INSERT INTO `ip_clients` (`client_id`, `account_id`, `client_date_created`, `client_date_modified`, `client_name`, `client_address_1`, `client_address_2`, `client_city`, `client_state`, `client_zip`, `client_country`, `client_phone`, `client_fax`, `client_mobile`, `client_email`, `client_web`, `client_vat_id`, `client_tax_code`, `client_language`, `client_active`, `client_surname`, `client_title`, `client_avs`, `client_insurednumber`, `client_veka`, `client_birthdate`, `client_gender`) VALUES
(1, 1, '2025-01-21 23:08:16', '2025-01-21 23:08:16', 'Nevim', '', '', '', '', '', 'CZ', '', '', '', '', '', '', '', 'system', 1, '', 'custom', NULL, NULL, NULL, '0000-00-00', 0),
(2, NULL, '2025-08-14 20:45:52', '2025-08-14 20:45:52', 'Jouda', '', '', '', '', '', 'CZ', '', '', '', '', '', '', '', 'system', 1, 'Klas', 'custom', NULL, NULL, NULL, '0000-00-00', 0),
(3, 10, '2025-08-15 01:37:23', '2025-08-15 01:37:23', 'tomáš', '', '', '', '', '', 'CZ', '', '', '', '', '', '', '', 'system', 1, '', 'custom', NULL, NULL, NULL, '0000-00-00', 0),
(4, 10, '2025-08-15 01:53:32', '2025-08-15 01:53:32', 'co ja vim', '', '', '', '', '', 'CZ', '', '', '', '', '', '', '', 'system', 1, '', 'custom', NULL, NULL, NULL, '0000-00-00', 0),
(5, 10, '2025-08-15 01:54:26', '2025-08-15 01:54:26', 'co ja vim2', '', '', '', '', '', 'CZ', '', '', '', '', '', '', '', 'system', 1, '', 'custom', NULL, NULL, NULL, '0000-00-00', 0);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_client_custom`
--

CREATE TABLE IF NOT EXISTS `ip_client_custom` (
  `client_custom_id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `client_custom_fieldid` int NOT NULL,
  `client_custom_fieldvalue` text COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`client_custom_id`),
  UNIQUE KEY `client_id` (`client_id`,`client_custom_fieldid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_client_notes`
--

CREATE TABLE IF NOT EXISTS `ip_client_notes` (
  `client_note_id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `client_note_date` date NOT NULL,
  `client_note` longtext NOT NULL,
  PRIMARY KEY (`client_note_id`),
  KEY `client_id` (`client_id`,`client_note_date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_custom_fields`
--

CREATE TABLE IF NOT EXISTS `ip_custom_fields` (
  `custom_field_id` int NOT NULL AUTO_INCREMENT,
  `custom_field_table` varchar(50) DEFAULT NULL,
  `custom_field_label` varchar(50) DEFAULT NULL,
  `custom_field_type` varchar(255) NOT NULL DEFAULT 'TEXT',
  `custom_field_location` int DEFAULT '0',
  `custom_field_order` int DEFAULT '999',
  PRIMARY KEY (`custom_field_id`),
  UNIQUE KEY `custom_field_table_2` (`custom_field_table`,`custom_field_label`),
  KEY `custom_field_table` (`custom_field_table`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_custom_values`
--

CREATE TABLE IF NOT EXISTS `ip_custom_values` (
  `custom_values_id` int NOT NULL AUTO_INCREMENT,
  `custom_values_field` int NOT NULL,
  `custom_values_value` text NOT NULL,
  PRIMARY KEY (`custom_values_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_email_templates`
--

CREATE TABLE IF NOT EXISTS `ip_email_templates` (
  `email_template_id` int NOT NULL AUTO_INCREMENT,
  `email_template_title` text,
  `email_template_type` varchar(255) DEFAULT NULL,
  `email_template_body` longtext NOT NULL,
  `email_template_subject` text,
  `email_template_from_name` text,
  `email_template_from_email` text,
  `email_template_cc` text,
  `email_template_bcc` text,
  `email_template_pdf_template` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`email_template_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_families`
--

CREATE TABLE IF NOT EXISTS `ip_families` (
  `family_id` int NOT NULL AUTO_INCREMENT,
  `family_name` text,
  PRIMARY KEY (`family_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_imports`
--

CREATE TABLE IF NOT EXISTS `ip_imports` (
  `import_id` int NOT NULL AUTO_INCREMENT,
  `import_date` datetime NOT NULL,
  PRIMARY KEY (`import_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_import_details`
--

CREATE TABLE IF NOT EXISTS `ip_import_details` (
  `import_detail_id` int NOT NULL AUTO_INCREMENT,
  `import_id` int NOT NULL,
  `import_lang_key` varchar(35) NOT NULL,
  `import_table_name` varchar(35) NOT NULL,
  `import_record_id` int NOT NULL,
  PRIMARY KEY (`import_detail_id`),
  KEY `import_id` (`import_id`,`import_record_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoices`
--

CREATE TABLE IF NOT EXISTS `ip_invoices` (
  `invoice_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `user_id` int NOT NULL,
  `client_id` int NOT NULL,
  `invoice_group_id` int NOT NULL,
  `invoice_status_id` tinyint NOT NULL DEFAULT '1',
  `is_read_only` tinyint(1) DEFAULT NULL,
  `invoice_password` varchar(90) DEFAULT NULL,
  `invoice_date_created` date NOT NULL,
  `invoice_time_created` time NOT NULL DEFAULT '00:00:00',
  `invoice_date_modified` datetime NOT NULL,
  `invoice_date_due` date NOT NULL,
  `invoice_number` varchar(100) DEFAULT NULL,
  `invoice_discount_amount` decimal(20,2) DEFAULT NULL,
  `invoice_discount_percent` decimal(20,2) DEFAULT NULL,
  `invoice_terms` longtext NOT NULL,
  `invoice_url_key` char(32) NOT NULL,
  `payment_method` int NOT NULL DEFAULT '0',
  `creditinvoice_parent_id` int DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  UNIQUE KEY `invoice_url_key` (`invoice_url_key`),
  KEY `user_id` (`user_id`,`client_id`,`invoice_group_id`,`invoice_date_created`,`invoice_date_due`,`invoice_number`),
  KEY `invoice_status_id` (`invoice_status_id`),
  KEY `idx_invoices_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=3 ;

--
-- Vypisuji data pro tabulku `ip_invoices`
--

INSERT INTO `ip_invoices` (`invoice_id`, `account_id`, `user_id`, `client_id`, `invoice_group_id`, `invoice_status_id`, `is_read_only`, `invoice_password`, `invoice_date_created`, `invoice_time_created`, `invoice_date_modified`, `invoice_date_due`, `invoice_number`, `invoice_discount_amount`, `invoice_discount_percent`, `invoice_terms`, `invoice_url_key`, `payment_method`, `creditinvoice_parent_id`) VALUES
(1, 1, 1, 1, 3, 1, NULL, '', '2025-01-21', '23:08:21', '2025-01-21 23:09:57', '2025-02-20', '1', '0.00', '0.00', '', '8yNm2JMW36RXDCfSZG0QnH7IYe4Fr1oA', 0, NULL),
(2, NULL, 6, 2, 3, 2, NULL, '', '2025-08-14', '20:45:56', '2025-08-14 20:46:27', '2025-09-13', '2', '0.00', '0.00', '', '12fcpHbkoR45IXj0QL7wNuetZDGS6ai9', 0, NULL),
(3, NULL, 8, 5, 3, 1, NULL, '', '2025-08-15', '01:56:24', '2025-08-15 01:56:35', '2025-09-14', '3', NULL, NULL, '', '8Z9MJR6EKjoTQYq7lIOdyxrHWifu0PsD', 0, NULL),
(4, NULL, 8, 5, 3, 1, NULL, '', '2025-08-15', '01:56:24', '2025-08-15 01:56:41', '2025-09-14', '4', NULL, NULL, '', 'oaT4Q2JOlPpvtkd3f9EAXhGRK6IniH8z', 0, NULL),
(5, NULL, 8, 5, 3, 1, NULL, '', '2025-08-15', '01:59:57', '2025-08-15 01:59:59', '2025-09-14', '5', NULL, NULL, '', 'Yhku6BnreAXSTijlEbPCRtHJM8cD9Lx3', 0, NULL),
(6, NULL, 8, 5, 3, 1, NULL, '', '2025-08-15', '01:59:57', '2025-08-15 02:01:45', '2025-09-14', '6', NULL, NULL, '', 'ri6uoHs8q5nVAdw1EpJmGXCPWNDMgBZF', 0, NULL),
(7, NULL, 8, 5, 3, 1, NULL, '', '2025-08-15', '02:01:50', '2025-08-15 02:01:53', '2025-09-14', '7', NULL, NULL, '', 'PgjtoE5OCeHfTYnmzbK46V2U7qNGQx9k', 0, NULL),
(8, NULL, 8, 5, 3, 1, NULL, '', '2025-08-15', '02:09:22', '2025-08-15 02:09:24', '2025-09-14', '8', NULL, NULL, '', 'nFUz1vHNy4CmbVS3je2swpTfg69YJEOG', 0, NULL),
(9, NULL, 1, 1, 3, 1, NULL, '', '2025-08-15', '02:10:17', '2025-08-15 02:10:32', '2025-09-14', '9', NULL, NULL, '', 'DBcLx8uyJG9zbNKpXfqUdQvnZ4Foej23', 0, NULL),
(10, NULL, 1, 1, 3, 1, NULL, '', '2025-08-15', '02:10:17', '2025-08-15 02:10:39', '2025-09-14', '10', NULL, NULL, '', 'bjQeXEprOqgmATI7HWkzM3Gns68iPcCl', 0, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoices_recurring`
--

CREATE TABLE IF NOT EXISTS `ip_invoices_recurring` (
  `invoice_recurring_id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `recur_start_date` date NOT NULL,
  `recur_end_date` date DEFAULT NULL,
  `recur_frequency` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `recur_next_date` date DEFAULT NULL,
  PRIMARY KEY (`invoice_recurring_id`),
  KEY `invoice_id` (`invoice_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_amounts`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_amounts` (
  `invoice_amount_id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `invoice_sign` enum('1','-1') NOT NULL DEFAULT '1',
  `invoice_item_subtotal` decimal(20,2) DEFAULT NULL,
  `invoice_item_tax_total` decimal(20,2) DEFAULT NULL,
  `invoice_tax_total` decimal(20,2) DEFAULT NULL,
  `invoice_total` decimal(20,2) DEFAULT NULL,
  `invoice_paid` decimal(20,2) DEFAULT NULL,
  `invoice_balance` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`invoice_amount_id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `invoice_paid` (`invoice_paid`,`invoice_balance`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=3 ;

--
-- Vypisuji data pro tabulku `ip_invoice_amounts`
--

INSERT INTO `ip_invoice_amounts` (`invoice_amount_id`, `invoice_id`, `invoice_sign`, `invoice_item_subtotal`, `invoice_item_tax_total`, `invoice_tax_total`, `invoice_total`, `invoice_paid`, `invoice_balance`) VALUES
(1, 1, '1', '20000.00', '0.00', '0.00', '20000.00', '0.00', '20000.00'),
(2, 2, '1', '150000.00', '0.00', '0.00', '150000.00', '0.00', '150000.00'),
(3, 3, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(4, 4, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(5, 5, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(6, 6, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(7, 7, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(8, 8, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(9, 9, '1', NULL, NULL, NULL, NULL, NULL, NULL),
(10, 10, '1', NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_custom`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_custom` (
  `invoice_custom_id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `invoice_custom_fieldid` int NOT NULL,
  `invoice_custom_fieldvalue` text COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`invoice_custom_id`),
  UNIQUE KEY `invoice_id` (`invoice_id`,`invoice_custom_fieldid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_groups`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_groups` (
  `invoice_group_id` int NOT NULL AUTO_INCREMENT,
  `invoice_group_name` text,
  `invoice_group_identifier_format` varchar(255) NOT NULL,
  `invoice_group_next_id` int NOT NULL,
  `invoice_group_left_pad` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`invoice_group_id`),
  KEY `invoice_group_next_id` (`invoice_group_next_id`),
  KEY `invoice_group_left_pad` (`invoice_group_left_pad`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=5 ;

--
-- Vypisuji data pro tabulku `ip_invoice_groups`
--

INSERT INTO `ip_invoice_groups` (`invoice_group_id`, `invoice_group_name`, `invoice_group_identifier_format`, `invoice_group_next_id`, `invoice_group_left_pad`) VALUES
(3, 'Invoice Default', '{{{id}}}', 11, 0),
(4, 'Quote Default', 'QUO{{{id}}}', 2, 0);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_items`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `invoice_id` int NOT NULL,
  `item_tax_rate_id` int NOT NULL DEFAULT '0',
  `item_product_id` int DEFAULT NULL,
  `item_date_added` date NOT NULL,
  `item_task_id` int DEFAULT NULL,
  `item_name` text,
  `item_description` longtext,
  `item_quantity` decimal(20,8) DEFAULT NULL,
  `item_price` decimal(20,2) DEFAULT NULL,
  `item_discount_amount` decimal(20,2) DEFAULT NULL,
  `item_order` int NOT NULL DEFAULT '0',
  `item_is_recurring` tinyint(1) DEFAULT NULL,
  `item_product_unit` varchar(50) DEFAULT NULL,
  `item_product_unit_id` int DEFAULT NULL,
  `item_date` date DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `invoice_id` (`invoice_id`,`item_tax_rate_id`,`item_date_added`,`item_order`),
  KEY `fk_iitems_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=3 ;

--
-- Vypisuji data pro tabulku `ip_invoice_items`
--

INSERT INTO `ip_invoice_items` (`item_id`, `account_id`, `invoice_id`, `item_tax_rate_id`, `item_product_id`, `item_date_added`, `item_task_id`, `item_name`, `item_description`, `item_quantity`, `item_price`, `item_discount_amount`, `item_order`, `item_is_recurring`, `item_product_unit`, `item_product_unit_id`, `item_date`) VALUES
(1, 1, 1, 0, NULL, '2025-01-21', NULL, 'Práce', 'práce', '1.00000000', '20000.00', NULL, 1, NULL, NULL, NULL, NULL),
(2, NULL, 2, 0, NULL, '2025-08-14', NULL, 'jejda', '', '3.00000000', '50000.00', NULL, 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_item_amounts`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_item_amounts` (
  `item_amount_id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `item_subtotal` decimal(20,2) DEFAULT NULL,
  `item_tax_total` decimal(20,2) DEFAULT NULL,
  `item_discount` decimal(20,2) DEFAULT NULL,
  `item_total` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`item_amount_id`),
  KEY `item_id` (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=3 ;

--
-- Vypisuji data pro tabulku `ip_invoice_item_amounts`
--

INSERT INTO `ip_invoice_item_amounts` (`item_amount_id`, `item_id`, `item_subtotal`, `item_tax_total`, `item_discount`, `item_total`) VALUES
(1, 1, '20000.00', '0.00', '0.00', '20000.00'),
(2, 2, '150000.00', '0.00', '0.00', '150000.00');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_sumex`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_sumex` (
  `sumex_id` int NOT NULL AUTO_INCREMENT,
  `sumex_invoice` int NOT NULL,
  `sumex_reason` int NOT NULL,
  `sumex_diagnosis` varchar(500) NOT NULL,
  `sumex_observations` varchar(500) NOT NULL,
  `sumex_treatmentstart` date NOT NULL,
  `sumex_treatmentend` date NOT NULL,
  `sumex_casedate` date NOT NULL,
  `sumex_casenumber` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`sumex_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_invoice_tax_rates`
--

CREATE TABLE IF NOT EXISTS `ip_invoice_tax_rates` (
  `invoice_tax_rate_id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `tax_rate_id` int NOT NULL,
  `include_item_tax` int NOT NULL DEFAULT '0',
  `invoice_tax_rate_amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`invoice_tax_rate_id`),
  KEY `invoice_id` (`invoice_id`,`tax_rate_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_item_lookups`
--

CREATE TABLE IF NOT EXISTS `ip_item_lookups` (
  `item_lookup_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(100) NOT NULL DEFAULT '',
  `item_description` longtext NOT NULL,
  `item_price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`item_lookup_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_login_log`
--

CREATE TABLE IF NOT EXISTS `ip_login_log` (
  `login_name` varchar(100) COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `log_count` int DEFAULT '0',
  `log_create_timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`login_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci AUTO_INCREMENT=1 ;

--
-- Vypisuji data pro tabulku `ip_login_log`
--

INSERT INTO `ip_login_log` (`login_name`, `log_count`, `log_create_timestamp`) VALUES
('nevim@seznam.cz', 2, '2025-08-14 09:47:54'),
('michalbobek@seznam.cz', 1, '2025-08-14 09:48:33'),
('postmaster@itmb.cz', 3, '2025-08-14 10:19:59');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_merchant_responses`
--

CREATE TABLE IF NOT EXISTS `ip_merchant_responses` (
  `merchant_response_id` int NOT NULL AUTO_INCREMENT,
  `invoice_id` int NOT NULL,
  `merchant_response_successful` tinyint(1) DEFAULT '1',
  `merchant_response_date` date NOT NULL,
  `merchant_response_driver` varchar(35) NOT NULL,
  `merchant_response` varchar(255) NOT NULL,
  `merchant_response_reference` varchar(255) NOT NULL,
  PRIMARY KEY (`merchant_response_id`),
  KEY `merchant_response_date` (`merchant_response_date`),
  KEY `invoice_id` (`invoice_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_payments`
--

CREATE TABLE IF NOT EXISTS `ip_payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `invoice_id` int NOT NULL,
  `payment_method_id` int NOT NULL DEFAULT '0',
  `payment_date` date NOT NULL,
  `payment_amount` decimal(20,2) DEFAULT NULL,
  `payment_note` longtext NOT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `payment_method_id` (`payment_method_id`),
  KEY `payment_amount` (`payment_amount`),
  KEY `idx_payments_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_payment_custom`
--

CREATE TABLE IF NOT EXISTS `ip_payment_custom` (
  `payment_custom_id` int NOT NULL AUTO_INCREMENT,
  `payment_id` int NOT NULL,
  `payment_custom_fieldid` int NOT NULL,
  `payment_custom_fieldvalue` text COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`payment_custom_id`),
  UNIQUE KEY `payment_id` (`payment_id`,`payment_custom_fieldid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_payment_methods`
--

CREATE TABLE IF NOT EXISTS `ip_payment_methods` (
  `payment_method_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `payment_method_name` text,
  PRIMARY KEY (`payment_method_id`),
  KEY `fk_pmethods_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=3 ;

--
-- Vypisuji data pro tabulku `ip_payment_methods`
--

INSERT INTO `ip_payment_methods` (`payment_method_id`, `account_id`, `payment_method_name`) VALUES
(1, 1, 'Cash'),
(2, 1, 'Credit Card');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_products`
--

CREATE TABLE IF NOT EXISTS `ip_products` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `family_id` int DEFAULT NULL,
  `product_sku` text,
  `product_name` text,
  `product_description` longtext NOT NULL,
  `product_price` decimal(20,2) DEFAULT NULL,
  `purchase_price` decimal(20,2) DEFAULT NULL,
  `provider_name` text,
  `tax_rate_id` int DEFAULT NULL,
  `unit_id` int DEFAULT NULL,
  `product_tariff` int DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `idx_products_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_projects`
--

CREATE TABLE IF NOT EXISTS `ip_projects` (
  `project_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `client_id` int NOT NULL,
  `project_name` text,
  PRIMARY KEY (`project_id`),
  KEY `idx_projects_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_quotes`
--

CREATE TABLE IF NOT EXISTS `ip_quotes` (
  `quote_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `invoice_id` int NOT NULL DEFAULT '0',
  `user_id` int NOT NULL,
  `client_id` int NOT NULL,
  `invoice_group_id` int NOT NULL,
  `quote_status_id` tinyint NOT NULL DEFAULT '1',
  `quote_date_created` date NOT NULL,
  `quote_date_modified` datetime NOT NULL,
  `quote_date_expires` date NOT NULL,
  `quote_number` varchar(100) DEFAULT NULL,
  `quote_discount_amount` decimal(20,2) DEFAULT NULL,
  `quote_discount_percent` decimal(20,2) DEFAULT NULL,
  `quote_url_key` char(32) NOT NULL,
  `quote_password` varchar(90) DEFAULT NULL,
  `notes` longtext,
  PRIMARY KEY (`quote_id`),
  KEY `user_id` (`user_id`,`client_id`,`invoice_group_id`,`quote_date_created`,`quote_date_expires`,`quote_number`),
  KEY `invoice_id` (`invoice_id`),
  KEY `quote_status_id` (`quote_status_id`),
  KEY `idx_quotes_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=2 ;

--
-- Vypisuji data pro tabulku `ip_quotes`
--

INSERT INTO `ip_quotes` (`quote_id`, `account_id`, `invoice_id`, `user_id`, `client_id`, `invoice_group_id`, `quote_status_id`, `quote_date_created`, `quote_date_modified`, `quote_date_expires`, `quote_number`, `quote_discount_amount`, `quote_discount_percent`, `quote_url_key`, `quote_password`, `notes`) VALUES
(1, 1, 0, 1, 1, 4, 1, '2025-01-22', '2025-01-22 21:35:00', '2025-02-06', 'QUO1', '0.00', '0.00', '20h8Gg1BWNKpMJ5nmzbixQjUrdEZcVXL', '', '');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_quote_amounts`
--

CREATE TABLE IF NOT EXISTS `ip_quote_amounts` (
  `quote_amount_id` int NOT NULL AUTO_INCREMENT,
  `quote_id` int NOT NULL,
  `quote_item_subtotal` decimal(20,2) DEFAULT NULL,
  `quote_item_tax_total` decimal(20,2) DEFAULT NULL,
  `quote_tax_total` decimal(20,2) DEFAULT NULL,
  `quote_total` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`quote_amount_id`),
  KEY `quote_id` (`quote_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=2 ;

--
-- Vypisuji data pro tabulku `ip_quote_amounts`
--

INSERT INTO `ip_quote_amounts` (`quote_amount_id`, `quote_id`, `quote_item_subtotal`, `quote_item_tax_total`, `quote_tax_total`, `quote_total`) VALUES
(1, 1, '15000.00', '0.00', '0.00', '15000.00');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_quote_custom`
--

CREATE TABLE IF NOT EXISTS `ip_quote_custom` (
  `quote_custom_id` int NOT NULL AUTO_INCREMENT,
  `quote_id` int NOT NULL,
  `quote_custom_fieldid` int NOT NULL,
  `quote_custom_fieldvalue` text COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`quote_custom_id`),
  UNIQUE KEY `quote_id` (`quote_id`,`quote_custom_fieldid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_quote_items`
--

CREATE TABLE IF NOT EXISTS `ip_quote_items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `quote_id` int NOT NULL,
  `item_tax_rate_id` int NOT NULL,
  `item_product_id` int DEFAULT NULL,
  `item_date_added` date NOT NULL,
  `item_name` text,
  `item_description` text,
  `item_quantity` decimal(20,8) DEFAULT NULL,
  `item_price` decimal(20,2) DEFAULT NULL,
  `item_discount_amount` decimal(20,2) DEFAULT NULL,
  `item_order` int NOT NULL DEFAULT '0',
  `item_product_unit` varchar(50) DEFAULT NULL,
  `item_product_unit_id` int DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  KEY `quote_id` (`quote_id`,`item_date_added`,`item_order`),
  KEY `item_tax_rate_id` (`item_tax_rate_id`),
  KEY `fk_qitems_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=2 ;

--
-- Vypisuji data pro tabulku `ip_quote_items`
--

INSERT INTO `ip_quote_items` (`item_id`, `account_id`, `quote_id`, `item_tax_rate_id`, `item_product_id`, `item_date_added`, `item_name`, `item_description`, `item_quantity`, `item_price`, `item_discount_amount`, `item_order`, `item_product_unit`, `item_product_unit_id`) VALUES
(1, 1, 1, 0, NULL, '2025-01-22', 'nevim', '', '1.00000000', '15000.00', NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_quote_item_amounts`
--

CREATE TABLE IF NOT EXISTS `ip_quote_item_amounts` (
  `item_amount_id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `item_subtotal` decimal(20,2) DEFAULT NULL,
  `item_tax_total` decimal(20,2) DEFAULT NULL,
  `item_discount` decimal(20,2) DEFAULT NULL,
  `item_total` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`item_amount_id`),
  KEY `item_id` (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=2 ;

--
-- Vypisuji data pro tabulku `ip_quote_item_amounts`
--

INSERT INTO `ip_quote_item_amounts` (`item_amount_id`, `item_id`, `item_subtotal`, `item_tax_total`, `item_discount`, `item_total`) VALUES
(1, 1, '15000.00', '0.00', '0.00', '15000.00');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_quote_tax_rates`
--

CREATE TABLE IF NOT EXISTS `ip_quote_tax_rates` (
  `quote_tax_rate_id` int NOT NULL AUTO_INCREMENT,
  `quote_id` int NOT NULL,
  `tax_rate_id` int NOT NULL,
  `include_item_tax` int NOT NULL DEFAULT '0',
  `quote_tax_rate_amount` decimal(20,2) DEFAULT NULL,
  PRIMARY KEY (`quote_tax_rate_id`),
  KEY `quote_id` (`quote_id`),
  KEY `tax_rate_id` (`tax_rate_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_sessions`
--

CREATE TABLE IF NOT EXISTS `ip_sessions` (
  `id` varchar(128) COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `timestamp` int unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  KEY `ip_sessions_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_settings`
--

CREATE TABLE IF NOT EXISTS `ip_settings` (
  `setting_id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` longtext NOT NULL,
  PRIMARY KEY (`setting_id`),
  KEY `setting_key` (`setting_key`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=108 ;

--
-- Vypisuji data pro tabulku `ip_settings`
--

INSERT INTO `ip_settings` (`setting_id`, `setting_key`, `setting_value`) VALUES
(19, 'default_language', 'Czech'),
(20, 'date_format', 'd.m.Y'),
(21, 'currency_symbol', 'Kč'),
(22, 'currency_symbol_placement', 'after'),
(23, 'currency_code', 'CZK'),
(24, 'invoices_due_after', '30'),
(25, 'quotes_expire_after', '15'),
(26, 'default_invoice_group', '3'),
(27, 'default_quote_group', '4'),
(28, 'thousands_separator', '.'),
(29, 'decimal_point', ','),
(30, 'cron_key', 'PWmuHq21ISojlUcZ'),
(31, 'tax_rate_decimal_places', '2'),
(32, 'pdf_invoice_template', 'InvoicePlane'),
(33, 'pdf_invoice_template_paid', 'InvoicePlane - paid'),
(34, 'pdf_invoice_template_overdue', 'InvoicePlane - overdue'),
(35, 'pdf_quote_template', 'InvoicePlane'),
(36, 'public_invoice_template', 'InvoicePlane_Web'),
(37, 'public_quote_template', 'InvoicePlane_Web'),
(38, 'disable_sidebar', '1'),
(39, 'read_only_toggle', '4'),
(40, 'invoice_pre_password', ''),
(41, 'quote_pre_password', ''),
(42, 'email_pdf_attachment', '1'),
(43, 'generate_invoice_number_for_draft', '1'),
(44, 'generate_quote_number_for_draft', '1'),
(45, 'sumex', '0'),
(46, 'sumex_sliptype', '1'),
(47, 'sumex_canton', '0'),
(48, 'system_theme', 'invoiceplane'),
(49, 'default_hourly_rate', '0.00'),
(50, 'projects_enabled', '1'),
(51, 'pdf_quote_footer', ''),
(52, 'default_item_decimals', '2'),
(53, 'first_day_of_week', '1'),
(54, 'default_country', 'CZ'),
(55, 'default_list_limit', '15'),
(56, 'number_format', 'number_format_european'),
(57, 'quote_overview_period', 'this-month'),
(58, 'invoice_overview_period', 'this-month'),
(59, 'disable_quickactions', '0'),
(60, 'custom_title', ''),
(61, 'monospace_amounts', '0'),
(62, 'reports_in_new_tab', '0'),
(63, 'show_responsive_itemlist', '0'),
(64, 'bcc_mails_to_admin', '0'),
(65, 'default_invoice_terms', ''),
(66, 'invoice_default_payment_method', ''),
(67, 'mark_invoices_sent_pdf', '0'),
(68, 'include_zugferd', '0'),
(69, 'pdf_watermark', '0'),
(70, 'email_invoice_template', ''),
(71, 'email_invoice_template_paid', ''),
(72, 'email_invoice_template_overdue', ''),
(73, 'pdf_invoice_footer', ''),
(74, 'qr_code', '0'),
(75, 'qr_code_recipient', ''),
(76, 'qr_code_iban', ''),
(77, 'qr_code_bic', ''),
(78, 'qr_code_remittance_text', ''),
(79, 'automatic_email_on_recur', '0'),
(80, 'no_update_invoice_due_date_mail', '0'),
(81, 'sumex_role', '0'),
(82, 'sumex_place', '0'),
(83, 'default_quote_notes', ''),
(84, 'mark_quotes_sent_pdf', '0'),
(85, 'email_quote_template', ''),
(86, 'default_invoice_tax_rate', ''),
(87, 'default_item_tax_rate', ''),
(88, 'default_include_item_tax', ''),
(89, 'email_send_method', ''),
(90, 'smtp_server_address', ''),
(91, 'smtp_mail_from', ''),
(92, 'smtp_authentication', '0'),
(93, 'smtp_username', ''),
(94, 'smtp_port', ''),
(95, 'smtp_security', ''),
(96, 'smtp_verify_certs', '1'),
(97, 'enable_online_payments', '0'),
(98, 'gateway_stripe_enabled', '0'),
(99, 'gateway_stripe_apiKeyPublic', ''),
(100, 'gateway_stripe_currency', 'USD'),
(101, 'gateway_stripe_payment_method', ''),
(102, 'gateway_paypal_enabled', '0'),
(103, 'gateway_paypal_clientId', ''),
(104, 'gateway_paypal_testMode', '0'),
(105, 'gateway_paypal_currency', 'USD'),
(106, 'gateway_paypal_payment_method', ''),
(107, 'enable_permissive_search_clients', '1');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_tasks`
--

CREATE TABLE IF NOT EXISTS `ip_tasks` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `project_id` int NOT NULL,
  `task_name` text,
  `task_description` longtext NOT NULL,
  `task_price` decimal(20,2) DEFAULT NULL,
  `task_finish_date` date NOT NULL,
  `task_status` tinyint(1) NOT NULL,
  `tax_rate_id` int NOT NULL,
  PRIMARY KEY (`task_id`),
  KEY `idx_tasks_account` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_tax_rates`
--

CREATE TABLE IF NOT EXISTS `ip_tax_rates` (
  `tax_rate_id` int NOT NULL AUTO_INCREMENT,
  `account_id` bigint unsigned DEFAULT NULL,
  `tax_rate_name` text,
  `tax_rate_percent` decimal(5,2) NOT NULL,
  PRIMARY KEY (`tax_rate_id`),
  KEY `fk_taxrates_account` (`account_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=4 ;

--
-- Vypisuji data pro tabulku `ip_tax_rates`
--

INSERT INTO `ip_tax_rates` (`tax_rate_id`, `account_id`, `tax_rate_name`, `tax_rate_percent`) VALUES
(1, 1, 'DPH 21', '21.00'),
(2, 1, 'DPH 12', '12.00'),
(3, 1, 'DPH 0', '0.00');

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_units`
--

CREATE TABLE IF NOT EXISTS `ip_units` (
  `unit_id` int NOT NULL AUTO_INCREMENT,
  `unit_name` varchar(50) DEFAULT NULL,
  `unit_name_plrl` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_uploads`
--

CREATE TABLE IF NOT EXISTS `ip_uploads` (
  `upload_id` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `url_key` char(32) NOT NULL,
  `file_name_original` longtext NOT NULL,
  `file_name_new` longtext NOT NULL,
  `uploaded_date` date NOT NULL,
  PRIMARY KEY (`upload_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_users`
--

CREATE TABLE IF NOT EXISTS `ip_users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `user_type` int NOT NULL DEFAULT '0',
  `user_active` tinyint(1) DEFAULT '1',
  `user_date_created` datetime NOT NULL,
  `user_date_modified` datetime NOT NULL,
  `user_language` varchar(255) DEFAULT 'system',
  `user_name` text,
  `user_company` text,
  `user_address_1` text,
  `user_address_2` text,
  `user_city` text,
  `user_state` text,
  `user_zip` text,
  `user_country` text,
  `user_phone` text,
  `user_fax` text,
  `user_mobile` text,
  `user_email` varchar(191) NOT NULL,
  `user_password` varchar(60) NOT NULL,
  `user_web` text,
  `user_vat_id` text,
  `user_tax_code` text,
  `user_psalt` text,
  `user_all_clients` int NOT NULL DEFAULT '0',
  `user_passwordreset_token` varchar(100) DEFAULT '',
  `user_subscribernumber` varchar(40) DEFAULT NULL,
  `user_iban` varchar(34) DEFAULT NULL,
  `user_gln` bigint DEFAULT NULL,
  `user_rcc` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `idx_users_email` (`user_email`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=8 ;

--
-- Vypisuji data pro tabulku `ip_users`
--

INSERT INTO `ip_users` (`user_id`, `user_type`, `user_active`, `user_date_created`, `user_date_modified`, `user_language`, `user_name`, `user_company`, `user_address_1`, `user_address_2`, `user_city`, `user_state`, `user_zip`, `user_country`, `user_phone`, `user_fax`, `user_mobile`, `user_email`, `user_password`, `user_web`, `user_vat_id`, `user_tax_code`, `user_psalt`, `user_all_clients`, `user_passwordreset_token`, `user_subscribernumber`, `user_iban`, `user_gln`, `user_rcc`) VALUES
(1, 1, 1, '2025-01-21 22:58:54', '2025-01-21 22:58:54', 'Czech', 'Michal Bobek', NULL, 'Žihle 150', '', 'Žihle', '', '33165', 'CZ', '604219687', '', '', 'michalbobek@gmail.com', '$2a$10$dc332f74eefcc39db51f9OXstYlsesfsZ9UXJASLnS3xT6STxEswa', '', NULL, NULL, 'dc332f74eefcc39db51f9a', 0, '', NULL, NULL, NULL, NULL),
(8, 1, 1, '2025-08-15 01:31:43', '2025-08-15 01:31:43', 'system', 'Michal Bobek', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'postmaster@itmb.cz', '$2a$10$b5019db8a3c9495ddc880OsIC4Fv3mTXBC9osJuy/H7nWy/sx9oey', NULL, NULL, NULL, 'b5019db8a3c9495ddc880d', 0, '', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_user_clients`
--

CREATE TABLE IF NOT EXISTS `ip_user_clients` (
  `user_client_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `client_id` int NOT NULL,
  PRIMARY KEY (`user_client_id`),
  KEY `user_id` (`user_id`,`client_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_user_custom`
--

CREATE TABLE IF NOT EXISTS `ip_user_custom` (
  `user_custom_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `user_custom_fieldid` int NOT NULL,
  `user_custom_fieldvalue` text COLLATE utf8mb4_unicode_520_ci,
  PRIMARY KEY (`user_custom_id`),
  UNIQUE KEY `user_id` (`user_id`,`user_custom_fieldid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Struktura tabulky `ip_versions`
--

CREATE TABLE IF NOT EXISTS `ip_versions` (
  `version_id` int NOT NULL AUTO_INCREMENT,
  `version_date_applied` varchar(14) NOT NULL,
  `version_file` varchar(45) NOT NULL,
  `version_sql_errors` int NOT NULL,
  PRIMARY KEY (`version_id`),
  KEY `version_date_applied` (`version_date_applied`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8mb3 AUTO_INCREMENT=40 ;

--
-- Vypisuji data pro tabulku `ip_versions`
--

INSERT INTO `ip_versions` (`version_id`, `version_date_applied`, `version_file`, `version_sql_errors`) VALUES
(1, '1737496667', '000_1.0.0.sql', 0),
(2, '1737496670', '001_1.0.1.sql', 0),
(3, '1737496670', '002_1.0.2.sql', 0),
(4, '1737496670', '003_1.1.0.sql', 0),
(5, '1737496670', '004_1.1.1.sql', 0),
(6, '1737496670', '005_1.1.2.sql', 0),
(7, '1737496670', '006_1.2.0.sql', 0),
(8, '1737496670', '007_1.2.1.sql', 0),
(9, '1737496670', '008_1.3.0.sql', 0),
(10, '1737496670', '009_1.3.1.sql', 0),
(11, '1737496670', '010_1.3.2.sql', 0),
(12, '1737496670', '011_1.3.3.sql', 0),
(13, '1737496670', '012_1.4.0.sql', 0),
(14, '1737496670', '013_1.4.1.sql', 0),
(15, '1737496670', '014_1.4.2.sql', 0),
(16, '1737496670', '015_1.4.3.sql', 0),
(17, '1737496670', '016_1.4.4.sql', 0),
(18, '1737496670', '017_1.4.5.sql', 0),
(19, '1737496670', '018_1.4.6.sql', 0),
(20, '1737496671', '019_1.4.7.sql', 0),
(21, '1737496672', '020_1.4.8.sql', 0),
(22, '1737496672', '021_1.4.9.sql', 0),
(23, '1737496672', '022_1.4.10.sql', 0),
(24, '1737496672', '023_1.5.0.sql', 0),
(25, '1737496672', '024_1.5.1.sql', 0),
(26, '1737496672', '025_1.5.2.sql', 0),
(27, '1737496672', '026_1.5.3.sql', 0),
(28, '1737496672', '027_1.5.4.sql', 0),
(29, '1737496672', '028_1.5.5.sql', 0),
(30, '1737496672', '029_1.5.6.sql', 0),
(31, '1737496672', '030_1.5.7.sql', 0),
(32, '1737496672', '031_1.5.8.sql', 0),
(33, '1737496672', '032_1.5.9.sql', 0),
(34, '1737496672', '033_1.5.10.sql', 0),
(35, '1737496672', '034_1.5.11.sql', 0),
(36, '1737496672', '035_1.5.12.sql', 0),
(37, '1737496672', '036_1.6.sql', 0),
(38, '1737496672', '037_1.6.1.sql', 0),
(39, '1737496672', '038_1.6.2.sql', 0);

--
-- Omezení pro exportované tabulky
--

--
-- Omezení pro tabulku `ip_account_users`
--
ALTER TABLE `ip_account_users`
  ADD CONSTRAINT `fk_au_acc` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_au_user` FOREIGN KEY (`user_id`) REFERENCES `ip_users` (`user_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_clients`
--
ALTER TABLE `ip_clients`
  ADD CONSTRAINT `fk_clients_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_invoices`
--
ALTER TABLE `ip_invoices`
  ADD CONSTRAINT `fk_invoices_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_invoice_items`
--
ALTER TABLE `ip_invoice_items`
  ADD CONSTRAINT `fk_iitems_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_payments`
--
ALTER TABLE `ip_payments`
  ADD CONSTRAINT `fk_payments_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_payment_methods`
--
ALTER TABLE `ip_payment_methods`
  ADD CONSTRAINT `fk_pmethods_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_products`
--
ALTER TABLE `ip_products`
  ADD CONSTRAINT `fk_products_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_projects`
--
ALTER TABLE `ip_projects`
  ADD CONSTRAINT `fk_projects_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_quotes`
--
ALTER TABLE `ip_quotes`
  ADD CONSTRAINT `fk_quotes_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_quote_items`
--
ALTER TABLE `ip_quote_items`
  ADD CONSTRAINT `fk_qitems_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_tasks`
--
ALTER TABLE `ip_tasks`
  ADD CONSTRAINT `fk_tasks_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

--
-- Omezení pro tabulku `ip_tax_rates`
--
ALTER TABLE `ip_tax_rates`
  ADD CONSTRAINT `fk_taxrates_account` FOREIGN KEY (`account_id`) REFERENCES `ip_accounts` (`account_id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
