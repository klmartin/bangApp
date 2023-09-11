-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 07, 2023 at 02:25 PM
-- Server version: 5.7.23-23
-- PHP Version: 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `alitabaa_bangApp`
--

-- --------------------------------------------------------

--
-- Table structure for table `bang_battles`
--

CREATE TABLE `bang_battles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  `type` enum('image','video') COLLATE utf8mb4_unicode_ci NOT NULL,
  `battle1` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `battle2` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bang_battles`
--

INSERT INTO `bang_battles` (`id`, `body`, `type`, `battle1`, `battle2`, `created_at`, `updated_at`) VALUES
(1, 'Awesome battle of images', 'image', 'images/battle/amber1.jpeg', 'images/battle/amber2.jpeg', '2023-07-31 18:14:19', '2023-07-31 18:14:19'),
(2, 'Exciting image battle', 'image', 'images/battle/amber3.jpeg', 'images/battle/gigi1.jpeg', '2023-07-31 18:14:19', '2023-07-31 18:14:19'),
(3, 'Exciting image battle', 'image', 'images/battle/gigi2.jpeg', 'images/battle/gigi3.jpeg', '2023-07-31 18:14:19', '2023-07-31 18:14:19'),
(4, 'Exciting image battle', 'image', 'images/battle/gigi4.jpeg', 'images/battle/9CHDlPTwUxFFMSf2SM1AQCcLKd0Iz4zb5h9gBtH9.jpg', '2023-07-31 18:14:19', '2023-07-31 18:14:19');

-- --------------------------------------------------------

--
-- Table structure for table `bang_inspirations`
--

CREATE TABLE `bang_inspirations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `thumbnail` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tittle` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `view_count` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `video_url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `creator` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `profile_url` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bang_inspirations`
--

INSERT INTO `bang_inspirations` (`id`, `thumbnail`, `tittle`, `view_count`, `video_url`, `creator`, `profile_url`, `created_at`, `updated_at`) VALUES
(4, 'bang_logo.jpg', 'this is title', '0', '64a034d64920d.mp4', 'BangInspiration', 'bang_logo.jpg', '2023-07-01 11:14:46', '2023-07-01 11:14:46'),
(5, 'bang_logo.jpg', 'this is title', '0', '64a038ffcf499.mp4', 'BangInspiration', 'bang_logo.jpg', '2023-07-01 11:32:31', '2023-07-01 11:32:31');

-- --------------------------------------------------------

--
-- Table structure for table `bang_updates`
--

CREATE TABLE `bang_updates` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `caption` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `filename` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('video','image') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bang_updates`
--

INSERT INTO `bang_updates` (`id`, `caption`, `filename`, `type`, `created_at`, `updated_at`) VALUES
(2, 'Faiza amdharau diva wa diamond', '649d7f5109d74.jpeg', 'image', '2023-06-29 09:55:45', '2023-06-29 09:55:45'),
(3, 'Angela amkataa Harmonize', '649d7ff87efd9.mp4', 'video', '2023-06-29 09:58:32', '2023-06-29 09:58:32'),
(4, 'Bang Updates 1', '649dadfdd172a.jpeg', 'image', '2023-06-29 13:14:53', '2023-06-29 13:14:53'),
(5, 'Bang Updates 2', '649dae6bad629.jpeg', 'image', '2023-06-29 13:16:43', '2023-06-29 13:16:43'),
(6, 'Bang Updates 3', '649dae768ce58.jpeg', 'image', '2023-06-29 13:16:54', '2023-06-29 13:16:54'),
(7, 'Faiza amdharau diva wa diamond', '649d7f5109d74.jpeg', 'image', '2023-06-29 06:55:45', '2023-06-29 06:55:45'),
(8, 'Angela amkataa Harmonize', '649d7ff87efd9.mp4', 'video', '2023-06-29 06:58:32', '2023-06-29 06:58:32'),
(9, 'Bang Updates 1', '649dadfdd172a.jpeg', 'image', '2023-06-29 10:14:53', '2023-06-29 10:14:53'),
(10, 'Bang Updates 2', '649dae6bad629.jpeg', 'image', '2023-06-29 10:16:43', '2023-06-29 10:16:43'),
(11, 'Bang Updates 3', '649dae768ce58.jpeg', 'image', '2023-06-29 10:16:54', '2023-06-29 10:16:54'),
(12, 'Hatari sana', '64e9ae22790b5.jpg', 'image', '2023-08-26 12:47:46', '2023-08-26 12:47:46'),
(13, 'Ukiamua kumsaidia mtu msaidie tu....', '64e9b3b0be9de.jpg', 'image', '2023-08-26 13:11:28', '2023-08-26 13:11:28'),
(14, 'Mmmmmmm!!!wambea wenzangu hii kweli hii??', '64e9b42b0652d.jpg', 'image', '2023-08-26 13:13:31', '2023-08-26 13:13:31'),
(15, 'Ukimuona Gigy na mpenzi wako jua kuna jambo lao leoleo...', '64e9b4aa98487.jpg', 'image', '2023-08-26 13:15:38', '2023-08-26 13:15:38'),
(16, 'We Gigy weweee jamanii hahahahaaa', '64e9b53840e3f.jpg', 'image', '2023-08-26 13:18:00', '2023-08-26 13:18:00'),
(17, 'Au basi wacha nisiseme😀😀😀😀😀😀', '64e9b5b9b2284.jpg', 'image', '2023-08-26 13:20:09', '2023-08-26 13:20:09'),
(18, 'Kabisa aiseee uwiiiiii...', '64e9b6073f03a.jpg', 'image', '2023-08-26 13:21:27', '2023-08-26 13:21:27'),
(19, 'Huyu dada huyu jamani Mungu anamuona khaaaa😀😀😀😀', '64e9c0841173d.jpg', 'image', '2023-08-26 14:06:12', '2023-08-26 14:06:12'),
(20, 'Hawa siku zao zinahesabika.wataachana tuuii🤣🤣🤣', '64e9c0e16d54f.jpg', 'image', '2023-08-26 14:07:45', '2023-08-26 14:07:45'),
(21, 'Kimenuka😀😀😀😀', '64ea1f367c169.jpg', 'image', '2023-08-26 20:50:14', '2023-08-26 20:50:14'),
(22, 'King kiba hataki shobo🤠🤠🤠🤠', '64ea26a6009aa.jpg', 'image', '2023-08-26 21:21:58', '2023-08-26 21:21:58'),
(23, 'Ni kweli au kazingua huyu???', '64ea274348f17.jpg', 'image', '2023-08-26 21:24:35', '2023-08-26 21:24:35'),
(24, 'Comment ya wema sepetu kwenye page ya Haji Manara kuhusu Mange', '64ea286d5f4d9.jpg', 'image', '2023-08-26 21:29:33', '2023-08-26 21:29:33'),
(25, 'Kweli kabisa huyu mjinga alikua hajulikani kiviiile wabongo wamempa promo sana bora wangemchunia🤬🤬', '64ea299a8dead.jpg', 'image', '2023-08-26 21:34:34', '2023-08-26 21:34:34'),
(26, 'Ila Gigy🙌🙌🙌🙌', '64ea29fd1f610.jpg', 'image', '2023-08-26 21:36:13', '2023-08-26 21:36:13'),
(27, 'Ila Gigy🙌🙌🙌🙌', '64ea2a0577388.jpg', 'image', '2023-08-26 21:36:21', '2023-08-26 21:36:21'),
(28, 'Hamisa hivi kampa nini huyu jamaa kila saa anampost khaà!!!', '64ea2b7b903c6.jpg', 'image', '2023-08-26 21:42:35', '2023-08-26 21:42:35'),
(29, 'Hahahahahaa aisee wacha nicheke miee hivi huyu dula makabila Hela nyingi anaazijua kweli!!!🤠🤠🤠', '64ea2c04105e1.jpg', 'image', '2023-08-26 21:44:52', '2023-08-26 21:44:52'),
(30, 'Wambea wenzangu hii ni kweli hii???🤒🤒🤒🤒', '64eadb9e25a9b.jpg', 'image', '2023-08-27 10:14:06', '2023-08-27 10:14:06'),
(31, 'Cheni kitu gani watu wanahonga Ma Range na bado wanapigwa chini ebooo!!!', '64eadc2699971.jpg', 'image', '2023-08-27 10:16:22', '2023-08-27 10:16:22'),
(32, 'Mambo hayo🤒🤒', '64eaeedcce5f1.mp4', 'video', '2023-08-27 11:36:12', '2023-08-27 11:36:12'),
(33, 'Penzi la Paula na Marioo haliioni Christmas niamini mimi nimekaa palee😂😂', '64eaf2cccbeb9.mp4', 'image', '2023-08-27 11:53:00', '2023-08-27 11:53:00'),
(34, 'Hii imeenda hii....🤠🤠', '64eb658c352d4.mp4', 'image', '2023-08-27 20:02:36', '2023-08-27 20:02:36'),
(35, 'Huyu mmakonde mwezi mmoja kabadilisha wanawake zaidi ya wanne khaaa!!!', '64eb904454630.jpg', 'image', '2023-08-27 23:04:52', '2023-08-27 23:04:52'),
(36, 'Uhuni tu😙😙😙', '64eb9278afebf.jpg', 'image', '2023-08-27 23:14:16', '2023-08-27 23:14:16'),
(37, 'Kimenuka!!!', '64eb93a3924d1.jpg', 'image', '2023-08-27 23:19:15', '2023-08-27 23:19:15'),
(38, 'Hatariiii na nusu😀😀😀', '64eb96b3c29a4.jpg', 'image', '2023-08-27 23:32:19', '2023-08-27 23:32:19'),
(39, 'Mambo ya church hayo mama Paulaa', '64eb973562e2e.jpg', 'image', '2023-08-27 23:34:29', '2023-08-27 23:34:29'),
(40, 'Hii imeenda hii..vimiguu vya mange kama spoku za baiskeri.', '64eb97f0917cc.jpg', 'image', '2023-08-27 23:37:36', '2023-08-27 23:37:36'),
(41, 'Baba na mwana pendeza sana.', '64eb9850472c2.jpg', 'image', '2023-08-27 23:39:12', '2023-08-27 23:39:12'),
(42, 'Hili pozi kikwenu mnaliitaje!!!', '64eb9c71c22dc.jpg', 'image', '2023-08-27 23:56:49', '2023-08-27 23:56:49'),
(43, 'Lulu kapata bwana mwingine full mapicha♥️😲', '64eb9d5e785b4.jpg', 'image', '2023-08-28 00:00:46', '2023-08-28 00:00:46'),
(44, 'Nai huu mzigo wote wakwake kweli!!!!😀😀', '64eced5c12c5e.jpg', 'image', '2023-08-28 23:54:20', '2023-08-28 23:54:20'),
(45, 'Hatari sana Lushayna aisee...💯💯', '64ecee75cbb8b.jpg', 'image', '2023-08-28 23:59:01', '2023-08-28 23:59:01'),
(46, 'Haya sasa😲', '64ecf009e5bd7.jpg', 'image', '2023-08-29 00:05:45', '2023-08-29 00:05:45'),
(47, 'Hahahhaaaa mtaachana tu🤠🤠🤠🤠🤠', '64ee1841b091b.jpg', 'image', '2023-08-29 21:09:37', '2023-08-29 21:09:37'),
(48, 'Ugonvi mwingine tena unaanza hapa🤒🤒', '64ee191caf313.jpg', 'image', '2023-08-29 21:13:16', '2023-08-29 21:13:16'),
(49, 'Mambo mengi muda mchache..', '64ee19ac8ab81.jpg', 'image', '2023-08-29 21:15:40', '2023-08-29 21:15:40'),
(50, 'Makubwa!!!!😳😳', '64ee3a6d8ab42.jpg', 'image', '2023-08-29 23:35:25', '2023-08-29 23:35:25');

-- --------------------------------------------------------

--
-- Table structure for table `bang_update_comments`
--

CREATE TABLE `bang_update_comments` (
  `id` int(11) NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) UNSIGNED NOT NULL,
  `body` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bang_update_comments`
--

INSERT INTO `bang_update_comments` (`id`, `user_id`, `post_id`, `body`, `created_at`, `updated_at`) VALUES
(1, 6, 20, 'na kweli mzee siku sio nyingi', NULL, NULL),
(2, 6, 20, 'pisi kali hiyo', '2023-08-26 18:12:49', '2023-08-26 18:12:49'),
(3, 6, 20, 'pisi kali hiyo', '2023-08-26 19:16:37', '2023-08-26 19:16:37'),
(4, 6, 20, 'hello', '2023-08-26 19:16:51', '2023-08-26 19:16:51'),
(5, 6, 20, 'hello', '2023-08-26 19:18:40', '2023-08-26 19:18:40'),
(6, 6, 20, 'hello', '2023-08-26 19:31:05', '2023-08-26 19:31:05'),
(7, 6, 20, 'hii', '2023-08-26 19:41:57', '2023-08-26 19:41:57'),
(8, 6, 19, 'pisi kali hiyo', '2023-08-26 19:45:32', '2023-08-26 19:45:32'),
(9, 6, 19, 'hello', '2023-08-26 19:53:23', '2023-08-26 19:53:23'),
(10, 6, 19, 'hello man this is martin', '2023-08-26 19:55:15', '2023-08-26 19:55:15'),
(11, 6, 19, 'hello man this is martin', '2023-08-26 19:56:28', '2023-08-26 19:56:28'),
(12, 6, 19, 'hello man this is martin', '2023-08-26 19:58:55', '2023-08-26 19:58:55'),
(13, 6, 19, 'hello man this is martin', '2023-08-26 19:59:21', '2023-08-26 19:59:21'),
(14, 6, 19, 'hello man this is martin', '2023-08-26 20:03:08', '2023-08-26 20:03:08'),
(15, 6, 19, 'hello man this is martin', '2023-08-26 20:05:22', '2023-08-26 20:05:22'),
(16, 6, 19, 'hello this lizabell', '2023-08-26 20:06:23', '2023-08-26 20:06:23'),
(17, 6, 18, 'hi liz', '2023-08-26 20:06:58', '2023-08-26 20:06:58'),
(18, 6, 18, 'hi liz', '2023-08-26 20:19:13', '2023-08-26 20:19:13'),
(19, 6, 18, 'hi liz', '2023-08-26 20:27:40', '2023-08-26 20:27:40'),
(20, 6, 18, 'hello martin', '2023-08-26 20:30:28', '2023-08-26 20:30:28'),
(21, 6, 18, 'helo this ismartin', '2023-08-26 20:33:11', '2023-08-26 20:33:11'),
(22, 6, 18, 'hello this is lizabell', '2023-08-26 20:35:22', '2023-08-26 20:35:22'),
(23, 6, 18, 'this is a comment', '2023-08-26 20:42:26', '2023-08-26 20:42:26'),
(24, 6, 18, 'this is a comment new', '2023-08-26 20:44:40', '2023-08-26 20:44:40'),
(25, 6, 18, 'hello there', '2023-08-26 20:45:18', '2023-08-26 20:45:18'),
(26, 6, 17, 'hello', '2023-08-26 20:48:25', '2023-08-26 20:48:25'),
(27, 6, 17, 'hi man', '2023-08-26 20:48:44', '2023-08-26 20:48:44'),
(28, 6, 17, 'helo this is me', '2023-08-26 20:50:25', '2023-08-26 20:50:25'),
(29, 6, 17, 'hello this comment', '2023-08-26 20:58:41', '2023-08-26 20:58:41'),
(30, 6, 17, 'hello nigga', '2023-08-26 20:59:43', '2023-08-26 20:59:43'),
(31, 6, 16, 'hello niggaa', '2023-08-26 21:00:57', '2023-08-26 21:00:57'),
(32, 6, 21, 'hello nigga', '2023-08-26 21:08:45', '2023-08-26 21:08:45'),
(33, 6, 21, 'hello nigga', '2023-08-26 21:14:29', '2023-08-26 21:14:29'),
(34, 6, 21, 'this is comment', '2023-08-26 21:18:10', '2023-08-26 21:18:10'),
(35, 6, 21, 'hello man this me', '2023-08-26 21:22:12', '2023-08-26 21:22:12'),
(36, 6, 22, 'this is me', '2023-08-26 21:22:39', '2023-08-26 21:22:39'),
(37, 6, 23, 'hello Nita', '2023-08-26 21:26:25', '2023-08-26 21:26:25'),
(38, 6, 24, 'hello nigga', '2023-08-26 21:30:09', '2023-08-26 21:30:09'),
(39, 6, 24, 'hello nigga', '2023-08-26 21:33:55', '2023-08-26 21:33:55'),
(40, 6, 24, 'hello nigga whatsapp', '2023-08-26 21:35:34', '2023-08-26 21:35:34'),
(41, 6, 24, 'hello nigga', '2023-08-26 21:39:41', '2023-08-26 21:39:41'),
(42, 6, 24, 'hello nigga', '2023-08-26 21:47:03', '2023-08-26 21:47:03'),
(43, 6, 29, 'hello nigga', '2023-08-26 21:47:47', '2023-08-26 21:47:47'),
(44, 6, 29, 'hello whatsapp', '2023-08-26 21:49:46', '2023-08-26 21:49:46'),
(45, 6, 29, 'hello nigga whatsapp', '2023-08-26 21:50:23', '2023-08-26 21:50:23'),
(46, 6, 29, 'yo nigga', '2023-08-26 21:55:56', '2023-08-26 21:55:56'),
(47, 6, 29, 'hello', '2023-08-26 22:40:12', '2023-08-26 22:40:12'),
(48, 6, 29, 'you nigaa you made it', '2023-08-26 22:53:34', '2023-08-26 22:53:34'),
(49, 6, 29, 'nimtongeze', '2023-08-26 22:54:40', '2023-08-26 22:54:40'),
(50, 6, 29, 'hello aneth', '2023-08-26 22:55:37', '2023-08-26 22:55:37'),
(51, 6, 29, 'hi nigga', '2023-08-26 22:56:52', '2023-08-26 22:56:52'),
(52, 6, 29, 'martin kaboja', '2023-08-26 22:57:19', '2023-08-26 22:57:19'),
(53, 6, 29, 'hello nigga', '2023-08-26 23:00:59', '2023-08-26 23:00:59'),
(54, 6, 28, 'hi nigga', '2023-08-26 23:01:32', '2023-08-26 23:01:32'),
(55, 6, 28, 'hello nigga', '2023-08-26 23:17:32', '2023-08-26 23:17:32'),
(56, 6, 27, 'hello nigg', '2023-08-26 23:22:51', '2023-08-26 23:22:51'),
(57, 6, 27, 'helo nigga', '2023-08-26 23:28:34', '2023-08-26 23:28:34'),
(58, 6, 27, 'hello nigga whatapp', '2023-08-26 23:30:27', '2023-08-26 23:30:27'),
(59, 6, 26, 'hello nigga whatsapp', '2023-08-26 23:38:47', '2023-08-26 23:38:47'),
(60, 6, 27, 'hello how are you', '2023-08-26 23:43:27', '2023-08-26 23:43:27'),
(61, 6, 27, 'help me', '2023-08-26 23:44:39', '2023-08-26 23:44:39'),
(62, 6, 27, 'help me here please', '2023-08-27 00:05:36', '2023-08-27 00:05:36'),
(63, 6, 25, 'piga kazi', '2023-08-27 01:08:26', '2023-08-27 01:08:26'),
(64, 6, 25, 'piga kazi mzee', '2023-08-27 01:11:20', '2023-08-27 01:11:20'),
(65, 6, 25, 'hii imeenda', '2023-08-27 01:15:40', '2023-08-27 01:15:40'),
(67, 6, 4, 'mimer mkali sana', '2023-08-27 01:46:21', '2023-08-27 01:46:21'),
(68, 6, 4, 'amber ni noma', '2023-08-27 01:47:16', '2023-08-27 01:47:16'),
(69, 6, 31, 'hello', '2023-08-27 11:26:35', '2023-08-27 11:26:35'),
(70, 6, 29, 'martin kaboj', '2023-08-27 12:21:13', '2023-08-27 12:21:13'),
(71, 6, 43, 'sio kweli', '2023-08-28 01:43:17', '2023-08-28 01:43:17'),
(72, 6, 42, 'shayo', '2023-08-28 20:49:59', '2023-08-28 20:49:59'),
(73, 12, 48, 'sawa', '2023-09-06 23:23:05', '2023-09-06 23:23:05');

-- --------------------------------------------------------

--
-- Table structure for table `bang_update_likes`
--

CREATE TABLE `bang_update_likes` (
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `bang_update_likes`
--

INSERT INTO `bang_update_likes` (`user_id`, `post_id`, `created_at`, `updated_at`) VALUES
(1, 3, NULL, NULL),
(6, 3, NULL, NULL),
(6, 16, NULL, NULL),
(6, 17, NULL, NULL),
(6, 2, NULL, NULL),
(6, 7, NULL, NULL),
(6, 7, NULL, NULL),
(6, 20, NULL, NULL),
(6, 29, NULL, NULL),
(6, 39, NULL, NULL),
(6, 38, NULL, NULL),
(6, 37, NULL, NULL),
(6, 40, NULL, NULL),
(6, 32, NULL, NULL),
(6, 49, NULL, NULL),
(6, 50, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `battle_comments`
--

CREATE TABLE `battle_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `battles_id` bigint(20) UNSIGNED NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `battle_comments`
--

INSERT INTO `battle_comments` (`id`, `user_id`, `battles_id`, `body`, `created_at`, `updated_at`) VALUES
(1, 6, 1, 'this is the first comment', '2023-08-27 02:18:48', '2023-08-27 02:18:48'),
(3, 6, 1, 'this is a comment', '2023-08-27 02:18:48', '2023-08-27 02:18:48'),
(4, 6, 1, 'gigi mkali', '2023-08-27 02:24:51', '2023-08-27 02:24:51'),
(5, 6, 3, 'gigi noma', '2023-08-27 02:25:18', '2023-08-27 02:25:18'),
(6, 6, 3, 'gigy mkali sana', '2023-08-29 09:25:18', '2023-08-29 09:25:18'),
(7, 6, 3, 'hii imeenda hii', '2023-08-31 00:25:18', '2023-08-31 00:25:18'),
(8, 6, 2, 'gigy', '2023-09-04 00:57:26', '2023-09-04 00:57:26'),
(9, 6, 2, 'gigy', '2023-09-04 00:57:26', '2023-09-04 00:57:26'),
(10, 6, 2, 'amber😲😲', '2023-09-04 21:31:29', '2023-09-04 21:31:29'),
(11, 6, 2, 'amber😲😲', '2023-09-04 21:31:29', '2023-09-04 21:31:29'),
(12, 12, 1, 'poaa', '2023-09-06 23:38:10', '2023-09-06 23:38:10'),
(13, 12, 2, 'poaa', '2023-09-08 00:03:04', '2023-09-08 00:03:04');

-- --------------------------------------------------------

--
-- Table structure for table `battle_likes`
--

CREATE TABLE `battle_likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `battle_id` bigint(20) UNSIGNED NOT NULL,
  `like_type` enum('A','B') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `created_at`, `updated_at`) VALUES
(1, 'Angelo Kilback', 'angelo-kilback', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(2, 'Okey Vandervort', 'okey-vandervort', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(3, 'Rafaela McCullough', 'rafaela-mccullough', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(4, 'Jeff Bahringer', 'jeff-bahringer', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(5, 'Jakob Gerhold', 'jakob-gerhold', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(6, 'Imogene Pfannerstill Jr.', 'imogene-pfannerstill-jr', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(7, 'Dr. Bartholome Swaniawski', 'dr-bartholome-swaniawski', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(8, 'Timmothy Steuber PhD', 'timmothy-steuber-phd', '2023-05-13 02:11:52', '2023-05-13 02:11:52');

-- --------------------------------------------------------

--
-- Table structure for table `challenges`
--

CREATE TABLE `challenges` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `challenge_img` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  `type` enum('image','video') COLLATE utf8mb4_unicode_ci NOT NULL,
  `public_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `confirmed` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `challenges`
--

INSERT INTO `challenges` (`id`, `post_id`, `user_id`, `challenge_img`, `body`, `type`, `public_id`, `confirmed`, `created_at`, `updated_at`) VALUES
(20, 14, 3, 'challenges/AzK6C0ksEpvTlQVEyIejrIvUBxWlN5e6Ob1HoErS.png', NULL, 'image', NULL, 1, '2023-07-25 16:39:02', '2023-07-25 16:39:02'),
(21, 13, 1, 'challenges/4qImOnF6jlOG4Cg58lbV9JKOyBnb1h8wIZtzs3xR.png', NULL, 'image', NULL, 0, '2023-07-27 16:27:49', '2023-07-27 16:27:49'),
(22, 13, 1, 'challenges/I9EXlFiTk7FfDJ7BM4j2g93SjJS85B8YIvLEZ055.png', NULL, 'image', NULL, 0, '2023-07-27 16:32:57', '2023-07-27 16:32:57'),
(23, 13, 1, 'challenges/b4lPFEGRUME17CLnxuNA4VT6uNyrwk3pHVZWeXDk.png', NULL, 'image', NULL, 0, '2023-07-27 16:49:36', '2023-07-27 16:49:36'),
(24, 13, 1, 'challenges/Vse2WEpnEYVB1Z5trOn368IV2FgwhCBg2TJFCEFB.png', NULL, 'image', NULL, 0, '2023-07-27 16:57:23', '2023-07-27 16:57:23'),
(25, 13, 1, 'challenges/2AADKxddVjSZ7Oa0930T8RbxCNITT482Gbofy2Wo.png', NULL, 'image', NULL, 1, '2023-07-27 16:58:21', '2023-07-27 16:58:21'),
(26, 13, 1, 'challenges/Xm3ROhq7I8NV6Tuwo7XPUpjUlFxrmnTiWAzVhjyb.png', NULL, 'image', NULL, 0, '2023-07-27 17:00:31', '2023-07-27 17:00:31'),
(27, 13, 1, 'challenges/g1BwAwJv9nKf37Qlgcok4ybQNIvnNEHqfJ9cwdvh.png', NULL, 'image', NULL, 0, '2023-07-27 17:03:24', '2023-07-27 17:03:24'),
(28, 13, 1, 'challenges/5TPSwBWbZvmlpiD2t5cIedSclEP5DzSeVrIDMc3c.png', NULL, 'image', NULL, 1, '2023-07-27 18:15:19', '2023-07-27 18:15:19'),
(29, 13, 1, 'challenges/OLv9B1OFxrD5b2qNiyOmVF8EKWvbHlOvXc0XPDtV.png', NULL, 'image', NULL, 0, '2023-07-27 18:20:28', '2023-07-27 18:20:28'),
(30, 13, 1, 'challenges/8JMskDQ2Ht56PvFlb0EQ2OUNtVH1apncGPwqGdfr.png', NULL, 'image', NULL, 0, '2023-07-27 18:31:25', '2023-07-27 18:31:25'),
(31, 13, 1, 'challenges/J4U69GlXsOc2vYU3Wrls1PGJkjRwNIHAWtS45q3w.png', NULL, 'image', NULL, 0, '2023-07-31 18:41:02', '2023-07-31 18:41:02'),
(32, 13, 1, 'challenges/uuOmGhC5nMLDjmku4vSgvT3iVTg1F6O42ZrpxOn6.png', NULL, 'image', NULL, 0, '2023-07-31 18:41:03', '2023-07-31 18:41:03'),
(33, 14, 1, 'challenges/H7pk7zM840x8pITEnRgPcJ8l6OyNWWNlT3IHeC4L.png', NULL, 'image', NULL, 0, '2023-07-31 18:42:33', '2023-07-31 18:42:33'),
(34, 62, 12, 'challenges/COcwWZQ815EMzcl8C799BnolSMZhwegAkFFdQSQ8.png', NULL, 'image', NULL, 0, '2023-09-07 11:19:39', '2023-09-07 11:19:39');

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) UNSIGNED NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `user_id`, `post_id`, `body`, `created_at`, `updated_at`) VALUES
(13, 6, 6, 'hey', '2023-07-08 07:35:44', '2023-07-08 07:35:44'),
(18, 6, 35, 'hio', '2023-08-22 02:20:51', '2023-08-22 02:20:51'),
(19, 6, 35, 'hio', '2023-08-22 02:20:59', '2023-08-22 02:20:59'),
(20, 6, 33, 'hello', '2023-08-22 02:22:08', '2023-08-22 02:22:08'),
(21, 6, 33, 'hello', '2023-08-22 02:22:22', '2023-08-22 02:22:22'),
(22, 6, 33, 'crispin', '2023-08-22 02:25:18', '2023-08-22 02:25:18'),
(25, 6, 20, 'vcvcv', '2023-08-26 18:07:13', '2023-08-26 18:07:13'),
(26, 6, 51, 'hello here', '2023-08-26 18:25:51', '2023-08-26 18:25:51'),
(27, 6, 51, 'this is another comment', '2023-08-27 01:45:25', '2023-08-27 01:45:25'),
(28, 6, 50, 'thi is a video', '2023-08-27 01:46:53', '2023-08-27 01:46:53'),
(38, 6, 3, 'gigy katisha', '2023-08-27 01:57:12', '2023-08-27 01:57:12'),
(39, 6, 3, 'gigy katisha', '2023-08-27 01:57:19', '2023-08-27 01:57:19'),
(40, 6, 3, 'gigy katisha', '2023-08-27 01:57:20', '2023-08-27 01:57:20'),
(41, 6, 3, 'gigy katisha', '2023-08-27 01:57:20', '2023-08-27 01:57:20'),
(42, 6, 3, 'gigy katisha', '2023-08-27 01:57:20', '2023-08-27 01:57:20'),
(43, 6, 3, 'gigy katisha', '2023-08-27 01:57:35', '2023-08-27 01:57:35'),
(63, 6, 51, 'hello is comment', '2023-08-28 02:12:48', '2023-08-28 02:12:48'),
(64, 6, 65, 'hatari na nusu', '2023-08-28 21:04:08', '2023-08-28 21:04:08'),
(65, 6, 65, 'hatari na nusu', '2023-08-28 21:04:08', '2023-08-28 21:04:08'),
(66, 6, 68, 'shayo', '2023-08-29 09:26:33', '2023-08-29 09:26:33'),
(67, 6, 68, 'shayo', '2023-08-29 09:26:34', '2023-08-29 09:26:34'),
(68, 6, 64, 'hhhhh', '2023-08-29 12:25:04', '2023-08-29 12:25:04'),
(69, 6, 68, 'mambo ya sarakasi tena!!!😆😆😆', '2023-08-31 00:23:15', '2023-08-31 00:23:15'),
(70, 6, 67, 'hatari', '2023-08-31 00:23:54', '2023-08-31 00:23:54'),
(71, 6, 67, 'hii imeenda hii', '2023-08-31 00:24:05', '2023-08-31 00:24:05'),
(72, 6, 70, 'hello', '2023-09-01 13:59:45', '2023-09-01 13:59:45'),
(73, 6, 70, 'hi this a comment', '2023-09-04 23:02:44', '2023-09-04 23:02:44'),
(74, 12, 71, 'vpp', '2023-09-06 22:36:03', '2023-09-06 22:36:03'),
(75, 12, 69, 'hello', '2023-09-07 10:03:10', '2023-09-07 10:03:10'),
(76, 12, 69, 'poa bhan', '2023-09-07 10:16:05', '2023-09-07 10:16:05'),
(77, 12, 71, 'vpp', '2023-09-07 10:30:32', '2023-09-07 10:30:32'),
(78, 12, 66, 'yuuu', '2023-09-07 10:31:22', '2023-09-07 10:31:22'),
(79, 12, 63, 'sawaa', '2023-09-07 10:35:45', '2023-09-07 10:35:45'),
(80, 12, 63, 'yuu', '2023-09-07 10:37:11', '2023-09-07 10:37:11'),
(81, 12, 63, 'hyugtyuy', '2023-09-07 10:42:19', '2023-09-07 10:42:19'),
(82, 12, 63, 'bad poassa', '2023-09-07 10:42:37', '2023-09-07 10:42:37'),
(83, 12, 68, 'gggg', '2023-09-07 10:44:04', '2023-09-07 10:44:04'),
(84, 12, 68, 'tyyyu', '2023-09-07 11:14:06', '2023-09-07 11:14:06'),
(85, 12, 71, 'poa bhan', '2023-09-07 23:53:42', '2023-09-07 23:53:42'),
(86, 12, 69, 'hello', '2023-09-08 00:16:20', '2023-09-08 00:16:20'),
(87, 12, 63, 'poaa', '2023-09-08 00:19:27', '2023-09-08 00:19:27');

-- --------------------------------------------------------

--
-- Table structure for table `deleted_posts`
--

CREATE TABLE `deleted_posts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `body` text COLLATE utf8mb4_unicode_ci,
  `type` enum('image','video') COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `challenge_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pinned` tinyint(4) NOT NULL DEFAULT '0',
  `public_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `deleted_posts`
--

INSERT INTO `deleted_posts` (`id`, `user_id`, `body`, `type`, `image`, `challenge_img`, `pinned`, `public_id`, `created_at`, `updated_at`) VALUES
(2, 3, '3', 'image', 'images/8OAIZdvw157In7QTBiL19FV3iOqlXE7kJGJjWZlK.png', NULL, 0, NULL, '2023-07-22 07:06:28', '2023-07-22 07:06:28'),
(3, 6, '6', 'image', 'images/LcW1FAfOGeKEQvvaAdbMTfJRaGWKsj7fzI5MnATb.jpg', NULL, 0, NULL, '2023-07-22 10:50:16', '2023-07-22 10:50:16'),
(4, 6, '6', 'image', 'images/hmm98JKyslaQBECdScISGTv1iShsuVSt0TTWQqxD.jpg', NULL, 0, NULL, '2023-07-22 11:17:35', '2023-07-22 11:17:35');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `favorites`
--

CREATE TABLE `favorites` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `favorited_id` bigint(20) UNSIGNED NOT NULL,
  `favorited_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `followers`
--

CREATE TABLE `followers` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `follower_id` bigint(20) UNSIGNED NOT NULL,
  `following_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `followers`
--

INSERT INTO `followers` (`id`, `follower_id`, `following_id`) VALUES
(1, 3, 1),
(2, 3, 1);

-- --------------------------------------------------------

--
-- Table structure for table `hobbies`
--

CREATE TABLE `hobbies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hobbies`
--

INSERT INTO `hobbies` (`id`, `name`, `created_at`, `updated_at`) VALUES
(508, 'Reading', NULL, NULL),
(509, 'Cooking', NULL, NULL),
(510, 'Hiking', NULL, NULL),
(511, '3D printing', NULL, NULL),
(512, 'Amateur radio', NULL, NULL),
(513, 'Scrapbook', NULL, NULL),
(514, 'Acting', NULL, NULL),
(515, 'Baton twirling', NULL, NULL),
(516, 'Board games', NULL, NULL),
(517, 'Book restoration', NULL, NULL),
(518, 'Cabaret', NULL, NULL),
(519, 'Calligraphy', NULL, NULL),
(520, 'Candle making', NULL, NULL),
(521, 'Computer programming', NULL, NULL),
(522, 'Coffee roasting', NULL, NULL),
(523, 'Colouring', NULL, NULL),
(524, 'Cosplaying', NULL, NULL),
(525, 'Couponing', NULL, NULL),
(526, 'Creative writing', NULL, NULL),
(527, 'Crocheting', NULL, NULL),
(528, 'Cryptography', NULL, NULL),
(529, 'Dance', NULL, NULL),
(530, 'Digital arts', NULL, NULL),
(531, 'Drama', NULL, NULL),
(532, 'Drawing', NULL, NULL),
(533, 'Do it yourself', NULL, NULL),
(534, 'Electronics', NULL, NULL),
(535, 'Embroidery', NULL, NULL),
(536, 'Fashion', NULL, NULL),
(537, 'Flower arranging', NULL, NULL),
(538, 'Foreign language learning', NULL, NULL),
(539, 'Gaming', NULL, NULL),
(540, 'Tabletop games', NULL, NULL),
(541, 'Role-playing games', NULL, NULL),
(542, 'Gambling', NULL, NULL),
(543, 'Genealogy', NULL, NULL),
(544, 'Glassblowing', NULL, NULL),
(545, 'Gunsmithing', NULL, NULL),
(546, 'Homebrewing', NULL, NULL),
(547, 'Ice skating', NULL, NULL),
(548, 'Jewelry making', NULL, NULL),
(549, 'Jigsaw puzzles', NULL, NULL),
(550, 'Juggling', NULL, NULL),
(551, 'Knapping', NULL, NULL),
(552, 'Knitting', NULL, NULL),
(553, 'Kabaddi', NULL, NULL),
(554, 'Knife making', NULL, NULL),
(555, 'Lacemaking', NULL, NULL),
(556, 'Lapidary', NULL, NULL),
(557, 'Leather crafting', NULL, NULL),
(558, 'Lego building', NULL, NULL),
(559, 'Lockpicking', NULL, NULL),
(560, 'Machining', NULL, NULL),
(561, 'Macrame', NULL, NULL),
(562, 'Metalworking', NULL, NULL),
(563, 'Magic', NULL, NULL),
(564, 'Model building', NULL, NULL),
(565, 'Listening to music', NULL, NULL),
(566, 'Origami', NULL, NULL),
(567, 'Painting', NULL, NULL),
(568, 'Playing musical instruments', NULL, NULL),
(569, 'Pet', NULL, NULL),
(570, 'Poi', NULL, NULL),
(571, 'Pottery', NULL, NULL),
(572, 'Puzzles', NULL, NULL),
(573, 'Quilting', NULL, NULL),
(574, 'Scrapbooking', NULL, NULL),
(575, 'Sculpting', NULL, NULL),
(576, 'Sewing', NULL, NULL),
(577, 'Singing', NULL, NULL),
(578, 'Sketching', NULL, NULL),
(579, 'Soapmaking', NULL, NULL),
(580, 'Sports', NULL, NULL),
(581, 'Stand-up comedy', NULL, NULL),
(582, 'Sudoku', NULL, NULL),
(583, 'Table tennis', NULL, NULL),
(584, 'Taxidermy', NULL, NULL),
(585, 'Video gaming', NULL, NULL),
(586, 'Watching movies', NULL, NULL),
(587, 'Web surfing', NULL, NULL),
(588, 'Whittling', NULL, NULL),
(589, 'Wood carving', NULL, NULL),
(590, 'Woodworking', NULL, NULL),
(591, 'World Building', NULL, NULL),
(592, 'Writing', NULL, NULL),
(593, 'Yoga', NULL, NULL),
(594, 'Yo-yoing', NULL, NULL),
(595, 'Air sports', NULL, NULL),
(596, 'Archery', NULL, NULL),
(597, 'Astronomy', NULL, NULL),
(598, 'Backpacking', NULL, NULL),
(599, 'Base jumping', NULL, NULL),
(600, 'Baseball', NULL, NULL),
(601, 'Basketball', NULL, NULL),
(602, 'Beekeeping', NULL, NULL),
(603, 'Bird watching', NULL, NULL),
(604, 'Blacksmithing', NULL, NULL),
(605, 'Board sports', NULL, NULL),
(606, 'Bodybuilding', NULL, NULL),
(607, 'Brazilian jiu-jitsu', NULL, NULL),
(608, 'Community', NULL, NULL),
(609, 'Cycling', NULL, NULL),
(610, 'Dowsing', NULL, NULL),
(611, 'Driving', NULL, NULL),
(612, 'Fishing', NULL, NULL),
(613, 'Flag football', NULL, NULL),
(614, 'Flying', NULL, NULL),
(615, 'Flying disc', NULL, NULL),
(616, 'Foraging', NULL, NULL),
(617, 'Gardening', NULL, NULL),
(618, 'Geocaching', NULL, NULL),
(619, 'Ghost hunting', NULL, NULL),
(620, 'Graffiti', NULL, NULL),
(621, 'Handball', NULL, NULL),
(622, 'Hooping', NULL, NULL),
(623, 'Horseback riding', NULL, NULL),
(624, 'Hunting', NULL, NULL),
(625, 'Inline skating', NULL, NULL),
(626, 'Jogging', NULL, NULL),
(627, 'Kayaking', NULL, NULL),
(628, 'Kite flying', NULL, NULL),
(629, 'Kitesurfing', NULL, NULL),
(630, 'Larping', NULL, NULL),
(631, 'Letterboxing', NULL, NULL),
(632, 'Metal detecting', NULL, NULL),
(633, 'Motor sports', NULL, NULL),
(634, 'Mountain biking', NULL, NULL),
(635, 'Mountaineering', NULL, NULL),
(636, 'Mushroom hunting', NULL, NULL),
(637, 'Mycology', NULL, NULL),
(638, 'Netball', NULL, NULL),
(639, 'Nordic skating', NULL, NULL),
(640, 'Orienteering', NULL, NULL),
(641, 'Paintball', NULL, NULL),
(642, 'Parkour', NULL, NULL),
(643, 'Photography', NULL, NULL),
(644, 'Polo', NULL, NULL),
(645, 'Rafting', NULL, NULL),
(646, 'Rappelling', NULL, NULL),
(647, 'Rock climbing', NULL, NULL),
(648, 'Roller skating', NULL, NULL),
(649, 'Rugby', NULL, NULL),
(650, 'Running', NULL, NULL),
(651, 'Sailing', NULL, NULL),
(652, 'Sand art', NULL, NULL),
(653, 'Scouting', NULL, NULL),
(654, 'Scuba diving', NULL, NULL),
(655, 'Sculling', NULL, NULL),
(656, 'Rowing', NULL, NULL),
(657, 'Shooting', NULL, NULL),
(658, 'Shopping', NULL, NULL),
(659, 'Skateboarding', NULL, NULL),
(660, 'Skiing', NULL, NULL),
(661, 'Skim Boarding', NULL, NULL),
(662, 'Skydiving', NULL, NULL),
(663, 'Slacklining', NULL, NULL),
(664, 'Snowboarding', NULL, NULL),
(665, 'Stone skipping', NULL, NULL),
(666, 'Surfing', NULL, NULL),
(667, 'Swimming', NULL, NULL),
(668, 'Taekwondo', NULL, NULL),
(669, 'Tai chi', NULL, NULL),
(670, 'Urban exploration', NULL, NULL),
(671, 'Vacation', NULL, NULL),
(672, 'Vehicle restoration', NULL, NULL),
(673, 'Water sports', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `likes`
--

CREATE TABLE `likes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `post_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `like_type` enum('A','B') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'A'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `likes`
--

INSERT INTO `likes` (`id`, `user_id`, `post_id`, `created_at`, `updated_at`, `like_type`) VALUES
(20, 6, 5, NULL, NULL, 'A'),
(37, 10, 5, NULL, NULL, 'A'),
(38, 10, 5, NULL, NULL, 'B'),
(67, 10, 14, NULL, NULL, 'A'),
(76, 1, 13, NULL, NULL, 'A'),
(77, 1, 11, NULL, NULL, 'A'),
(78, 1, 6, NULL, NULL, 'A'),
(82, 10, 15, NULL, NULL, 'B'),
(86, 10, 16, NULL, NULL, 'A'),
(87, 10, 23, NULL, NULL, 'A'),
(88, 6, 26, NULL, NULL, 'A'),
(92, 6, 35, NULL, NULL, 'A'),
(93, 6, 32, NULL, NULL, 'A'),
(102, 6, 49, NULL, NULL, 'B'),
(109, 6, 50, NULL, NULL, 'B'),
(110, 6, 58, NULL, NULL, 'B'),
(111, 6, 57, NULL, NULL, 'B'),
(112, 6, 55, NULL, NULL, 'B'),
(118, 6, 34, NULL, NULL, 'B'),
(120, 6, 33, NULL, NULL, 'B'),
(151, 6, 62, NULL, NULL, 'B'),
(156, 6, 66, NULL, NULL, 'A'),
(173, 6, 70, NULL, NULL, 'A'),
(182, 6, 72, NULL, NULL, 'B'),
(185, 6, 64, NULL, NULL, 'A');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sender_id` bigint(20) UNSIGNED NOT NULL,
  `receiver_id` bigint(20) UNSIGNED NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `created_at`, `updated_at`) VALUES
(1, 10, 6, 'Hello Martin this is Chrispin here', NULL, NULL),
(2, 6, 10, 'hello Chrispin this is my message', NULL, NULL),
(3, 10, 6, 'Hello Martin im reminding you to work on that issue asap', NULL, NULL),
(4, 3, 6, 'hello this is my first message', NULL, NULL),
(5, 3, 6, 'hello this is my second message', NULL, NULL),
(6, 6, 10, 'helo', '2023-08-13 10:22:01', '2023-08-13 10:22:01'),
(7, 6, 10, 'hello', '2023-08-13 10:36:56', '2023-08-13 10:36:56');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(51, '2014_10_12_000000_create_users_table', 1),
(52, '2014_10_12_100000_create_password_resets_table', 1),
(53, '2016_06_01_000001_create_oauth_auth_codes_table', 1),
(54, '2016_06_01_000002_create_oauth_access_tokens_table', 1),
(55, '2016_06_01_000003_create_oauth_refresh_tokens_table', 1),
(56, '2016_06_01_000004_create_oauth_clients_table', 1),
(57, '2016_06_01_000005_create_oauth_personal_access_clients_table', 1),
(58, '2019_08_19_000000_create_failed_jobs_table', 1),
(59, '2020_06_05_102233_create_categories_table', 1),
(60, '2020_06_05_103613_create_posts_table', 1),
(61, '2020_06_05_153154_create_comments_table', 1),
(62, '2020_06_05_170822_create_favorites_table', 1),
(64, '2020_06_19_220146_create_followers_table', 1),
(65, '2023_04_17_130704_create_images_table', 1),
(66, '2023_05_08_100346_create_likes_table', 1),
(70, '2023_06_29_122510_create_bang_updates_table', 1),
(71, '2023_07_01_114457_create_bang_inspirations_table', 1),
(72, '2023_07_08_121817_bang_update_likes', 2),
(73, '2023_07_08_122810_bang_update_comments', 2),
(75, '2023_07_22_085846_create_deleted_posts_table', 3),
(78, '2023_07_25_153828_create_challenges_table', 4),
(79, '2020_06_05_175343_create_notifications_table', 5),
(80, '2023_07_30_084122_create_hobbies_table', 6),
(81, '2023_07_30_115108_create_user_hobby_table', 7),
(82, '2023_07_31_190259_create_bang_battles_table', 8),
(83, '2023_07_31_190437_create_battle_likes_table', 9),
(85, '2023_07_31_192726_create_battle_comments_table', 10),
(86, '2023_08_13_083723_create_messages_table', 11),
(87, '0000_00_00_000000_create_websockets_statistics_entries_table', 12);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_read` tinyint(4) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_access_tokens`
--

CREATE TABLE `oauth_access_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_auth_codes`
--

CREATE TABLE `oauth_auth_codes` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `scopes` text COLLATE utf8mb4_unicode_ci,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_clients`
--

CREATE TABLE `oauth_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `secret` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `provider` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `redirect` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `personal_access_client` tinyint(1) NOT NULL,
  `password_client` tinyint(1) NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_personal_access_clients`
--

CREATE TABLE `oauth_personal_access_clients` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `client_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `oauth_refresh_tokens`
--

CREATE TABLE `oauth_refresh_tokens` (
  `id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_token_id` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `revoked` tinyint(1) NOT NULL,
  `expires_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `body` varchar(10000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` enum('image','video') COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `challenge_img` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pinned` tinyint(1) NOT NULL DEFAULT '0',
  `public_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `video_height` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `user_id`, `body`, `type`, `image`, `challenge_img`, `pinned`, `public_id`, `created_at`, `updated_at`, `video_height`) VALUES
(3, 3, 'martin', 'video', 'images/videos/video1.mp4', NULL, 0, NULL, '2023-05-13 11:37:38', '2023-05-13 11:37:38', NULL),
(5, 3, 'martin', 'image', 'images/KmKgZhNQQ7VCt3OyAK8zNCiRV9ltbjb6PfEyXsgF.jpg', 'images/cdvLCB7UIpFT1UbA0BHwmwrCbCjLvUdM0m5xrbtm.jpg', 0, NULL, '2023-05-13 11:38:52', '2023-05-13 11:38:52', NULL),
(6, 3, 'martin', 'image', 'images/wPbqpadNRBWgHVAFFtL01VqtWsOVtkg92wufiXEf.jpg', NULL, 0, NULL, '2023-05-13 11:39:08', '2023-05-13 11:39:08', NULL),
(9, 6, 'martin', 'image', 'images/wPbqpadNRBWgHVAFFtL01VqtWsOVtkg92wufiXEf.jpg', NULL, 1, NULL, '2023-05-13 11:39:08', '2023-05-13 11:39:08', NULL),
(11, 3, NULL, 'image', 'images/G3S4KkusV78aIcKJ82E9ckP4krc9a7mACXZD3HMJ.png', NULL, 0, NULL, '2023-07-22 04:22:31', '2023-07-22 04:22:31', NULL),
(13, 6, NULL, 'image', 'images/kmkeDTeEu5Ym7DdEvj2LPUoLXVVe4tj5Y8xiyV1K.png', NULL, 0, NULL, '2023-07-25 13:12:21', '2023-07-25 13:12:21', NULL),
(14, 1, NULL, 'image', 'images/4LzNOoU21VXq5rscxiisycdWjmKe5gta7V6MVuNU.png', NULL, 0, NULL, '2023-07-25 16:33:48', '2023-07-25 16:33:48', NULL),
(15, 1, NULL, 'image', 'images/ZMwavZ4ZM9OOXU2SXvmZaix3pr7uEYinH41ZjPFS.png', 'images/eL5gCCkcEu3lamJrBrZuoZyXGdTZRwuc3WOi2Psy.png', 0, NULL, '2023-07-30 04:46:38', '2023-07-30 04:46:38', NULL),
(16, 1, NULL, 'image', 'images/e7eakRFmuQiQvfVCKb3CDgzpt7o8bGnGZS9YpFpp.png', 'images/UTkPsZgTKS9V5soE8MVmW4iBOHHDP7bFGDU59vBK.png', 0, NULL, '2023-07-30 04:47:27', '2023-07-30 04:47:27', NULL),
(17, 3, 'martin', 'video', 'images/videos/video1.mp4', NULL, 0, NULL, '2023-05-13 08:37:38', '2023-05-13 08:37:38', NULL),
(18, 3, 'martin', 'image', 'images/KmKgZhNQQ7VCt3OyAK8zNCiRV9ltbjb6PfEyXsgF.jpg', 'images/cdvLCB7UIpFT1UbA0BHwmwrCbCjLvUdM0m5xrbtm.jpg', 0, NULL, '2023-05-13 08:38:52', '2023-05-13 08:38:52', NULL),
(19, 3, 'martin', 'image', 'images/wPbqpadNRBWgHVAFFtL01VqtWsOVtkg92wufiXEf.jpg', NULL, 0, NULL, '2023-05-13 08:39:08', '2023-05-13 08:39:08', NULL),
(20, 6, 'martin', 'image', 'images/wPbqpadNRBWgHVAFFtL01VqtWsOVtkg92wufiXEf.jpg', NULL, 1, NULL, '2023-05-13 08:39:08', '2023-05-13 08:39:08', NULL),
(21, 3, NULL, 'image', 'images/G3S4KkusV78aIcKJ82E9ckP4krc9a7mACXZD3HMJ.png', NULL, 0, NULL, '2023-07-22 01:22:31', '2023-07-22 01:22:31', NULL),
(22, 6, NULL, 'image', 'images/kmkeDTeEu5Ym7DdEvj2LPUoLXVVe4tj5Y8xiyV1K.png', NULL, 0, NULL, '2023-07-25 10:12:21', '2023-07-25 10:12:21', NULL),
(23, 1, NULL, 'image', 'images/4LzNOoU21VXq5rscxiisycdWjmKe5gta7V6MVuNU.png', NULL, 0, NULL, '2023-07-25 13:33:48', '2023-07-25 13:33:48', NULL),
(24, 1, NULL, 'image', 'images/ZMwavZ4ZM9OOXU2SXvmZaix3pr7uEYinH41ZjPFS.png', 'images/eL5gCCkcEu3lamJrBrZuoZyXGdTZRwuc3WOi2Psy.png', 0, NULL, '2023-07-30 01:46:38', '2023-07-30 01:46:38', NULL),
(25, 1, NULL, 'image', 'images/e7eakRFmuQiQvfVCKb3CDgzpt7o8bGnGZS9YpFpp.png', 'images/UTkPsZgTKS9V5soE8MVmW4iBOHHDP7bFGDU59vBK.png', 0, NULL, '2023-07-30 01:47:27', '2023-07-30 01:47:27', NULL),
(26, 1, NULL, 'image', 'images/va5KAspBrvknE4iqPvMxOK8gufHnYmX0H1WE8YXz.png', NULL, 0, NULL, '2023-08-08 12:23:08', '2023-08-08 12:23:08', NULL),
(27, 1, NULL, 'image', 'images/ztyQF8XZvCdypgzZTMtyrhpBWszn8CPbcSedwgdY.png', NULL, 0, NULL, '2023-08-08 12:33:01', '2023-08-08 12:33:01', NULL),
(28, 1, NULL, 'image', 'images/9m6qpGButc67c7N3HRUjCQtbYv3OVzzjuVTXhqMe.png', NULL, 0, NULL, '2023-08-08 12:35:33', '2023-08-08 12:35:33', NULL),
(29, 6, 'hii picha ni kali sana', 'image', 'images/5RXJcTmSz36TY8lpkqGB5w5sinr7zZ89ky9ZTEXs.png', NULL, 0, NULL, '2023-08-08 13:22:09', '2023-08-08 13:22:09', NULL),
(30, 6, 'hii picha ni kali sana', 'image', 'images/Wjt9Q68aW01iW3tu29p06AJ8zzPevPRkhKOpdZ5W.png', NULL, 0, NULL, '2023-08-08 13:26:06', '2023-08-08 13:26:06', NULL),
(31, 6, 'hii picha ni kali sana', 'image', 'images/EU18H113tjyDRhc9zqBj2vHDAfa8VoB3HELczVEz.png', NULL, 0, NULL, '2023-08-08 13:38:51', '2023-08-08 13:38:51', NULL),
(32, 6, 'hii ni sebule yangu', 'image', 'images/yOwznGhNSqk7gqLckTSUng7PFx5YMYMP4qNOSFxA.png', NULL, 0, NULL, '2023-08-08 13:44:19', '2023-08-08 13:44:19', NULL),
(33, 6, 'caption yoyote', 'image', 'images/1ryPy0lNzdZrbUGaDDAJE77BJctucoIs9e0qjiaa.png', NULL, 0, NULL, '2023-08-08 13:46:26', '2023-08-08 13:46:26', NULL),
(34, 6, 'picha ya kwanza', 'image', 'images/vOU3TqRr5JkDXdsjkDdevtn7Xt77C0Pxyy3sJmCz.png', NULL, 0, NULL, '2023-08-08 14:21:47', '2023-08-08 14:21:47', NULL),
(35, 6, 'hii ndo picha ya kwanza', 'image', 'images/jVFKqV2y7ee0LeliL7tSJPnczJ3M4bqBTYv1ixhx.png', NULL, 0, NULL, '2023-08-08 14:50:29', '2023-08-08 14:50:29', NULL),
(49, 6, 'hello', 'video', 'images/ZnMCPXr8CwFvgJpvj57MTqxGzsB5flFZboBtNzxM.mp4', NULL, 0, NULL, '2023-08-22 01:04:43', '2023-08-22 01:04:43', NULL),
(50, 6, 'hello', 'video', 'images/uqGVSo8oLdkObbsGYui0CrW5kUvkd4bEg35izwmS.mp4', NULL, 0, NULL, '2023-08-22 01:30:00', '2023-08-22 01:30:00', NULL),
(51, 6, NULL, 'image', 'images/TKb1Omw4ZJ7y4ci5d3TQUOTPLnBYNcU8Y153pDkH.png', 'images/hM1Z68A1WY704ypMDwbC1Dp70T8Ib2cjhVyAKx21.png', 0, NULL, '2023-08-26 18:24:31', '2023-08-26 18:24:31', NULL),
(52, 6, NULL, 'image', 'images/Qh24hdpjl73wxxJCmjmBtMxgIBKwBv2XGn2ogp2J.png', 'images/JO8ikBir3lqwKwnOGwnT4VTG2l1bBxOD5MlUXoun.png', 0, NULL, '2023-08-26 18:24:39', '2023-08-26 18:24:39', NULL),
(53, 6, NULL, 'image', 'images/3HpwaKIBFPswuHbas6AXF57USgCPCJrIEgM2JgOZ.png', NULL, 0, NULL, '2023-08-27 23:28:08', '2023-08-27 23:28:08', NULL),
(54, 6, NULL, 'image', 'images/cQ6cz9qYJt9qnQowZvHzNQ03iVkhpB22mvSJJrKL.png', NULL, 0, NULL, '2023-08-27 23:33:54', '2023-08-27 23:33:54', NULL),
(55, 6, NULL, 'image', 'images/MTxt3AKUYaNSTdMB3qbzcoBCcoSWj8mAXJ5nURtq.png', NULL, 0, NULL, '2023-08-27 23:34:09', '2023-08-27 23:34:09', NULL),
(57, 6, 'anjella na harmoniaze', 'video', 'images/YzNc74NGZXEl6FGQaRkwEBbhq9FGNTUZm35E5HWc.mp4', NULL, 0, NULL, '2023-08-28 00:58:57', '2023-08-28 00:58:57', NULL),
(58, 6, 'humu ani angu', 'video', 'images/7BbSBJ5ltxEHCIK2oGoDDWC8UxILpHpV7SoWVHr2.mp4', NULL, 0, NULL, '2023-08-28 01:03:18', '2023-08-28 01:03:18', NULL),
(60, 6, NULL, 'image', 'images/6MVqTFrg64zIDw8lkzvwXhsTvqBG3gvqAV3AVXSR.png', NULL, 0, NULL, '2023-08-28 02:41:38', '2023-08-28 02:41:38', NULL),
(61, 6, NULL, 'image', 'images/kkXOhUhflBtn7uZep1gOuyjODDS70rzhGcxZkQpz.png', NULL, 1, NULL, '2023-08-28 02:41:39', '2023-08-28 02:41:39', NULL),
(62, 6, 'Mama Paula kaingia church hatari hii😀😀', 'image', 'images/9Al0UuSce7Nct6AJBF5zZqEarrZCHQ4838iabBwr.png', NULL, 0, NULL, '2023-08-28 11:11:53', '2023-08-28 11:11:53', NULL),
(63, 6, 'Mama Paula kaingia church hatari hii😀😀', 'image', 'images/OICLX0HrKI6JNPOjWSu9Z0XJ0ts7s1QSWM4IYDJ5.png', NULL, 0, NULL, '2023-08-28 11:11:55', '2023-08-28 11:11:55', NULL),
(64, 6, NULL, 'image', 'images/48U590mtOPWPxD4BzQHpOPakeTSzXzPiXSIJ59Ts.png', 'images/I1TdKFJKaeZ2tOC1hSHdBpX4riMS1FZMTL0DYwjb.png', 0, NULL, '2023-08-28 11:16:08', '2023-08-28 11:16:08', NULL),
(65, 6, NULL, 'image', 'images/NrDhqPMr4z40hu6GuGAzeWL9cXW6fGt5xiom4M8I.png', 'images/yyHJLXpGtX9O9klg1FmUYtbgrCzIUdITdKiZzO2n.png', 0, NULL, '2023-08-28 11:33:00', '2023-08-28 11:33:00', NULL),
(66, 6, NULL, 'image', 'images/ND58b4oy5CBRgBi3HIDItreeHPtbqOWVJRee8pRW.png', 'images/XLZxxDXumsQ5BLysyirWgwkPehWHpXHE9kSZ1Ycf.png', 0, NULL, '2023-08-28 22:33:27', '2023-08-28 22:33:27', NULL),
(67, 6, NULL, 'image', 'images/EL6jNMe6oMckssAZulxd6qKPn9oDy2zjoSjE8q9Q.png', 'images/ClNweOtQbiRymhO5xVMjJTKEaoHnoLIJSQoSkGzH.png', 0, NULL, '2023-08-28 22:33:36', '2023-08-28 22:33:36', NULL),
(68, 6, 'unyama mwingi...', 'image', 'images/NoiaQ3vB5JeYGmQhpiokQoZCYofMFbDXKgRrYdJN.png', NULL, 0, NULL, '2023-08-28 23:46:42', '2023-08-28 23:46:42', NULL),
(69, 6, 'unyama mwingi...', 'image', 'images/m9gSCQgZ0rgNC9GqD1vFwiAW9rvfgFU1uu7tP2bd.png', NULL, 0, NULL, '2023-08-28 23:46:43', '2023-08-28 23:46:43', NULL),
(70, 6, NULL, 'image', 'images/cLwjVpXa1Jehishr2mKEaST9f0z9q74lCJkn34op.png', 'images/7VWS2YiO0IORTnNB6AikO25npYAfPhnKqbY4TroP.png', 0, NULL, '2023-08-30 21:38:40', '2023-08-30 21:38:40', NULL),
(71, 6, NULL, 'image', 'images/8p4HGrOADatfifixB7zQRMRn3LX7cKQi5veRK450.png', 'images/JDcSncsUeamnLUSpFxDd6dszKrmI0dm6H5yDOduv.png', 0, NULL, '2023-08-30 21:39:03', '2023-08-30 21:39:03', NULL),
(72, 6, 'sanaaaaa', 'image', 'images/H92kEsmm6FMV2HEySKbY3iUdA3Dw6kGKirk8nvXX.png', NULL, 0, NULL, '2023-09-04 21:13:19', '2023-09-04 21:13:19', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(25) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bio` varchar(700) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` int(14) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `occupation` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `device_token` varchar(10000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `username`, `email`, `email_verified_at`, `image`, `bio`, `phone_number`, `date_of_birth`, `occupation`, `public_id`, `password`, `remember_token`, `device_token`, `created_at`, `updated_at`) VALUES
(1, 'crispin', 'martinkaboja@gmail.com', 'mohammed@gmail.com', NULL, 'bang_logo.jpg', 'chrispin', NULL, NULL, NULL, NULL, '$2y$10$zOwW8bHBeJcSYCYCamWiiuYT/JujlktWxvJ7CuO3j4.axzqBCTB2a', NULL, 'dzUHuiw9SKSZS69rFPP_rG:APA91bFQagXq1Fw68o_VAr26IXQu2UrlqpvMRgGViNjxHNJC7GrRfPdHPa2aKRXRvC027l1U8zXBB6FJm6FWq_JFO2JTyDGRy7XXtUh6rp38Cppv14xr4lIQbzR3jjc4Zmr0eBrAzYhH', '2023-05-13 02:11:51', '2023-07-30 12:27:14'),
(2, 'Mr. Vincenzo Heathcote', '', 'bstokes@example.net', '2023-05-13 02:11:51', 'bang_logo.jpg', '', NULL, NULL, NULL, NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'vVVcyj8Bci', 'vsddfewfef4rweed', '2023-05-13 02:11:51', '2023-07-23 13:02:38'),
(3, 'Kiara Rohan', '', 'fredrick.schumm@example.com', '2023-05-13 02:11:51', 'bang_logo.jpg', '', NULL, NULL, NULL, NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9Pj5oqlKMj', '', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(4, 'Ryder Padberg', '', 'jkeebler@example.com', '2023-05-13 02:11:51', 'bang_logo.jpg', '', NULL, NULL, NULL, NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '9QvPW8g9wB', '', '2023-05-13 02:11:51', '2023-05-13 02:11:51'),
(5, 'Judy O\'Kon DVM', '', 'gcrist@example.org', '2023-05-13 02:11:52', 'bang_logo.jpg', '', NULL, NULL, NULL, NULL, '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'BFLWJzn5A4', '', '2023-05-13 02:11:52', '2023-05-13 02:11:52'),
(6, 'martin', '', 'martin@gmail.com', NULL, 'bang_logo.jpg', '', NULL, NULL, NULL, NULL, '$2y$10$zOwW8bHBeJcSYCYCamWiiuYT/JujlktWxvJ7CuO3j4.axzqBCTB2a', NULL, 'fRVQwHeaTpi_4hLRXlsS2X:APA91bEVC0qfYRHPSHGs7T2vEdtP3rVp4ZAoUIhA0ZvCZAIZwsyXUyQfRBRScdn0RYzjS-pSRO_zC-GDgXMekKbhr8o9j-rix9kvCW7IH8VclU4FJrrlxrCXaNv-0-yPU3PqqN5cnuHQ', '2023-05-13 02:14:41', '2023-09-04 19:57:15'),
(10, 'chrispin', '', 'kisininichrispin@gmail.com', NULL, 'bang_logo.jpg', '', 710426565, '1993-07-01', NULL, NULL, '$2y$10$zOwW8bHBeJcSYCYCamWiiuYT/JujlktWxvJ7CuO3j4.axzqBCTB2a', NULL, 'dzUHuiw9SKSZS69rFPP_rG:APA91bFQagXq1Fw68o_VAr26IXQu2UrlqpvMRgGViNjxHNJC7GrRfPdHPa2aKRXRvC027l1U8zXBB6FJm6FWq_JFO2JTyDGRy7XXtUh6rp38Cppv14xr4lIQbzR3jjc4Zmr0eBrAzYhH', '2023-07-30 10:50:43', '2023-07-30 10:50:45'),
(11, 'herman', NULL, 'gidohermes@gmail.com', NULL, NULL, NULL, 621189850, '2000-09-30', NULL, NULL, '$2y$10$hH8ygvb1hdOL6zAHbA7asucN.K7Zmavsa0zilqjw8WLiW80YjYr4u', NULL, 'fzN6eumCTtGWDQlSODrDo0:APA91bGglgrDXkFK9nCeU-wjA7GrqqYhCgP72yaiN2A-C5RkLTX9AyPg0vEBFNdWjI1X5K0j86G2TnZWBRSTRwSSVnbM-g_uo5WSBgn3NK74WoKVXWYbmxfTNDViVpCrmPLNRny2CNFG', '2023-09-05 00:43:55', '2023-09-05 00:43:56'),
(12, 'hermanx', NULL, 'herman@gmail.com', NULL, NULL, NULL, 621189850, '1991-09-11', NULL, NULL, '$2y$10$kb/lLnQBswSl0naSzd1g7.XngS/V8p2V5x3QmyHLVJ38nno9JyDZi', NULL, 'c9-BscX7TE-vxFRuG8a1fi:APA91bHEwLQqOzxGMEfQBNix5cJe_pNrEDnjRCwvuod8p33Hh5JionqFxr-we5lwZ68YT-s0LAgaGewbqfU2frpWevUAql1-VzNypwmZZP-EhLqAk7Yrp8ozb-DM7Pzr3rurTxBk8cMF', '2023-09-06 01:24:24', '2023-09-07 23:42:33');

-- --------------------------------------------------------

--
-- Table structure for table `user_hobby`
--

CREATE TABLE `user_hobby` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `hobby_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_hobby`
--

INSERT INTO `user_hobby` (`id`, `user_id`, `hobby_id`, `created_at`, `updated_at`) VALUES
(10, 10, 608, '2023-07-30 10:50:43', '2023-07-30 10:50:43'),
(11, 10, 521, '2023-07-30 10:50:43', '2023-07-30 10:50:43'),
(12, 10, 509, '2023-07-30 10:50:43', '2023-07-30 10:50:43');

-- --------------------------------------------------------

--
-- Table structure for table `websockets_statistics_entries`
--

CREATE TABLE `websockets_statistics_entries` (
  `id` int(10) UNSIGNED NOT NULL,
  `app_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `peak_connection_count` int(11) NOT NULL,
  `websocket_message_count` int(11) NOT NULL,
  `api_message_count` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bang_battles`
--
ALTER TABLE `bang_battles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bang_inspirations`
--
ALTER TABLE `bang_inspirations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bang_updates`
--
ALTER TABLE `bang_updates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bang_update_comments`
--
ALTER TABLE `bang_update_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bang_update_comments_user_id_foreign` (`user_id`),
  ADD KEY `bang_update_comments_post_id_foreign` (`post_id`);

--
-- Indexes for table `bang_update_likes`
--
ALTER TABLE `bang_update_likes`
  ADD KEY `bang_update_likes_user_id_foreign` (`user_id`),
  ADD KEY `bang_update_likes_post_id_foreign` (`post_id`);

--
-- Indexes for table `battle_comments`
--
ALTER TABLE `battle_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `battle_comments_user_id_foreign` (`user_id`),
  ADD KEY `battle_comments_battles_id_foreign` (`battles_id`);

--
-- Indexes for table `battle_likes`
--
ALTER TABLE `battle_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `battle_likes_user_id_foreign` (`user_id`),
  ADD KEY `battle_likes_battle_id_foreign` (`battle_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `challenges`
--
ALTER TABLE `challenges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `challenges_post_id_foreign` (`post_id`),
  ADD KEY `challenges_user_id_foreign` (`user_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_post_id_foreign` (`post_id`);

--
-- Indexes for table `deleted_posts`
--
ALTER TABLE `deleted_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `deleted_posts_user_id_foreign` (`user_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `favorites`
--
ALTER TABLE `favorites`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `favorites_user_id_favorited_id_favorited_type_unique` (`user_id`,`favorited_id`,`favorited_type`);

--
-- Indexes for table `followers`
--
ALTER TABLE `followers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `followers_follower_id_foreign` (`follower_id`),
  ADD KEY `followers_following_id_foreign` (`following_id`);

--
-- Indexes for table `hobbies`
--
ALTER TABLE `hobbies`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `hobbies_name_unique` (`name`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `likes`
--
ALTER TABLE `likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `likes_user_id_foreign` (`user_id`),
  ADD KEY `likes_post_id_foreign` (`post_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `messages_sender_id_foreign` (`sender_id`),
  ADD KEY `messages_receiver_id_foreign` (`receiver_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`);

--
-- Indexes for table `oauth_access_tokens`
--
ALTER TABLE `oauth_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_access_tokens_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_auth_codes`
--
ALTER TABLE `oauth_auth_codes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_auth_codes_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_clients_user_id_index` (`user_id`);

--
-- Indexes for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `oauth_refresh_tokens`
--
ALTER TABLE `oauth_refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `oauth_refresh_tokens_access_token_id_index` (`access_token_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `posts_user_id_foreign` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_name_unique` (`name`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indexes for table `user_hobby`
--
ALTER TABLE `user_hobby`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_hobby_user_id_hobby_id_unique` (`user_id`,`hobby_id`),
  ADD KEY `user_hobby_hobby_id_foreign` (`hobby_id`);

--
-- Indexes for table `websockets_statistics_entries`
--
ALTER TABLE `websockets_statistics_entries`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bang_battles`
--
ALTER TABLE `bang_battles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `bang_inspirations`
--
ALTER TABLE `bang_inspirations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bang_updates`
--
ALTER TABLE `bang_updates`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `bang_update_comments`
--
ALTER TABLE `bang_update_comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `battle_comments`
--
ALTER TABLE `battle_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `battle_likes`
--
ALTER TABLE `battle_likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `challenges`
--
ALTER TABLE `challenges`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `deleted_posts`
--
ALTER TABLE `deleted_posts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `favorites`
--
ALTER TABLE `favorites`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `followers`
--
ALTER TABLE `followers`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `hobbies`
--
ALTER TABLE `hobbies`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=674;

--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `likes`
--
ALTER TABLE `likes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=187;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=88;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `oauth_clients`
--
ALTER TABLE `oauth_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `oauth_personal_access_clients`
--
ALTER TABLE `oauth_personal_access_clients`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `user_hobby`
--
ALTER TABLE `user_hobby`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `websockets_statistics_entries`
--
ALTER TABLE `websockets_statistics_entries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bang_update_comments`
--
ALTER TABLE `bang_update_comments`
  ADD CONSTRAINT `bang_update_comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `bang_updates` (`id`),
  ADD CONSTRAINT `bang_update_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `bang_update_likes`
--
ALTER TABLE `bang_update_likes`
  ADD CONSTRAINT `bang_update_likes_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `bang_updates` (`id`),
  ADD CONSTRAINT `bang_update_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `battle_comments`
--
ALTER TABLE `battle_comments`
  ADD CONSTRAINT `battle_comments_battles_id_foreign` FOREIGN KEY (`battles_id`) REFERENCES `bang_battles` (`id`),
  ADD CONSTRAINT `battle_comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `battle_likes`
--
ALTER TABLE `battle_likes`
  ADD CONSTRAINT `battle_likes_battle_id_foreign` FOREIGN KEY (`battle_id`) REFERENCES `bang_battles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `battle_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `challenges`
--
ALTER TABLE `challenges`
  ADD CONSTRAINT `challenges_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `challenges_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `deleted_posts`
--
ALTER TABLE `deleted_posts`
  ADD CONSTRAINT `deleted_posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `favorites`
--
ALTER TABLE `favorites`
  ADD CONSTRAINT `favorites_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `followers`
--
ALTER TABLE `followers`
  ADD CONSTRAINT `followers_follower_id_foreign` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `followers_following_id_foreign` FOREIGN KEY (`following_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `likes`
--
ALTER TABLE `likes`
  ADD CONSTRAINT `likes_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_receiver_id_foreign` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_sender_id_foreign` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `user_hobby`
--
ALTER TABLE `user_hobby`
  ADD CONSTRAINT `user_hobby_hobby_id_foreign` FOREIGN KEY (`hobby_id`) REFERENCES `hobbies` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_hobby_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
