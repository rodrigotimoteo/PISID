-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 22, 2024 at 05:43 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `PISID`
--

-- --------------------------------------------------------

--
-- Table structure for table `alerta`
--

CREATE TABLE `alerta` (
  `id_alerta` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sala` int(11) NOT NULL,
  `sensor` int(11) NOT NULL,
  `leitura` decimal(4,2) NOT NULL,
  `tipo_alerta` varchar(20) NOT NULL,
  `mensagem` varchar(100) DEFAULT NULL,
  `hora_escrita` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `estados_experiencia`
--

CREATE TABLE `estados_experiencia` (
  `estado_id` int(11) NOT NULL,
  `estado_nome` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `estados_experiencia`
--

INSERT INTO `estados_experiencia` (`estado_id`, `estado_nome`) VALUES
(1, 'terminada'),
(2, 'a decorrer'),
(3, 'por iniciar');

-- --------------------------------------------------------

--
-- Table structure for table `experiencia`
--

CREATE TABLE `experiencia` (
  `id_experiencia` int(11) NOT NULL,
  `descricao` text DEFAULT NULL,
  `estado_experiencia` int(11) NOT NULL,
  `investigador` varchar(50) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `numero_ratos` int(11) NOT NULL,
  `limite_ratos_sala` int(11) NOT NULL,
  `segundos_sem_movimento` int(11) NOT NULL,
  `temperatura_ideal` decimal(4,2) NOT NULL,
  `variacao_temperatura_maxima` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `experiencia`
--

INSERT INTO `experiencia` (`id_experiencia`, `descricao`, `estado_experiencia`, `investigador`, `datahora`, `numero_ratos`, `limite_ratos_sala`, `segundos_sem_movimento`, `temperatura_ideal`, `variacao_temperatura_maxima`) VALUES
(4, 'NovoProjecto', 3, 'arthurcabrao91@aiesec.net', '2024-03-22 15:23:45', 20, 15, 10, 16.00, 4.00);

-- --------------------------------------------------------

--
-- Table structure for table `medicoesPassagens`
--

CREATE TABLE `medicoesPassagens` (
  `id_medicacao` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `sala_origem` int(11) NOT NULL,
  `sala_destino` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medicoesPassagens`
--

INSERT INTO `medicoesPassagens` (`id_medicacao`, `hora`, `sala_origem`, `sala_destino`) VALUES
(1, '2024-03-20 20:35:22', 7, 5),
(2, '2024-03-20 20:35:22', 7, 5),
(3, '2024-03-20 20:35:23', 5, 3),
(4, '2024-03-20 20:35:23', 3, 2),
(5, '2024-03-20 20:35:23', 5, 7),
(6, '2024-03-20 20:35:23', 5, 3),
(7, '2024-03-20 20:35:23', 1, 3),
(8, '2024-03-20 20:35:24', 4, 5),
(9, '2024-03-20 20:35:24', 7, 5),
(10, '2024-03-20 20:35:24', 5, 7),
(11, '2024-03-20 20:35:24', 2, 5),
(12, '2024-03-20 20:35:25', 3, 2),
(13, '2024-03-20 20:35:25', 6, 8),
(14, '2024-03-20 20:35:25', 5, 7),
(15, '2024-03-20 20:35:25', 6, 8),
(16, '2024-03-20 20:35:26', 5, 3),
(17, '2024-03-20 20:35:26', 5, 6),
(18, '2024-03-20 20:35:26', 2, 4),
(19, '2024-03-21 11:55:28', 6, 8),
(20, '2024-03-21 11:55:28', 2, 4),
(21, '2024-03-21 11:55:28', 1, 3),
(22, '2024-03-21 11:55:28', 3, 2),
(23, '2024-03-21 11:55:29', 5, 3),
(24, '2024-03-21 11:55:29', 2, 4),
(25, '2024-03-21 11:55:30', 7, 5),
(26, '2024-03-21 11:55:31', 7, 5),
(27, '2024-03-21 11:55:31', 7, 5),
(28, '2024-03-21 11:55:31', 9, 7),
(29, '2024-03-21 11:55:31', 8, 10),
(30, '2024-03-21 11:55:31', 7, 5),
(31, '2024-03-21 11:55:31', 8, 9),
(32, '2024-03-21 11:55:31', 4, 5),
(33, '2024-03-21 11:55:31', 1, 3),
(34, '2024-03-21 11:55:31', 4, 5),
(35, '2024-03-21 11:55:31', 3, 2),
(36, '2024-03-21 11:55:32', 3, 2),
(37, '2024-03-21 11:55:32', 7, 5),
(38, '2024-03-21 11:55:32', 5, 7),
(39, '2024-03-21 11:55:33', 5, 6),
(40, '2024-03-21 11:55:33', 5, 7),
(41, '2024-03-21 11:55:33', 8, 10),
(42, '2024-03-21 11:55:33', 2, 4),
(43, '2024-03-21 11:55:34', 7, 5),
(44, '2024-03-21 11:55:34', 4, 5),
(45, '2024-03-21 11:55:34', 5, 3),
(46, '2024-03-21 11:55:34', 2, 5),
(47, '2024-03-21 11:55:34', 4, 5),
(48, '2024-03-21 11:55:34', 6, 8),
(49, '2024-03-21 11:55:34', 3, 2),
(50, '2024-03-21 11:55:35', 6, 8),
(51, '2024-03-21 11:55:35', 6, 8),
(52, '2024-03-21 11:55:35', 7, 5),
(53, '2024-03-21 11:55:35', 5, 7),
(54, '2024-03-21 11:55:35', 5, 6),
(55, '2024-03-21 11:55:35', 2, 5),
(56, '2024-03-21 11:55:36', 5, 3),
(57, '2024-03-21 11:55:36', 7, 5),
(58, '2024-03-21 11:55:36', 5, 3),
(59, '2024-03-21 11:55:37', 5, 7),
(60, '2024-03-21 11:55:37', 5, 7),
(61, '2024-03-21 11:55:37', 2, 4),
(62, '2024-03-21 11:55:37', 3, 2),
(63, '2024-03-21 11:55:37', 1, 2),
(64, '2024-03-21 11:55:38', 3, 2),
(65, '2024-03-21 11:55:38', 8, 9),
(66, '2024-03-21 11:55:38', 5, 7),
(67, '2024-03-21 11:55:38', 5, 7),
(68, '2024-03-21 11:55:39', 3, 2),
(69, '2024-03-21 11:55:39', 7, 5),
(70, '2024-03-21 11:55:39', 7, 5),
(71, '2024-03-21 11:55:40', 7, 5),
(72, '2024-03-21 11:55:40', 4, 5),
(73, '2024-03-21 11:55:40', 1, 2),
(74, '2024-03-21 11:55:41', 5, 6),
(75, '2024-03-21 11:55:41', 4, 5),
(76, '2024-03-21 11:55:41', 5, 3),
(77, '2024-03-21 11:55:41', 2, 5),
(78, '2024-03-21 11:55:42', 2, 4),
(79, '2024-03-21 11:55:42', 2, 4),
(80, '2024-03-21 11:55:42', 7, 5),
(81, '2024-03-21 11:55:42', 6, 8),
(82, '2024-03-21 11:55:43', 2, 4),
(83, '2024-03-21 11:55:43', 6, 8),
(84, '2024-03-21 11:55:43', 7, 5),
(85, '2024-03-21 11:55:43', 9, 7),
(86, '2024-03-21 11:55:43', 1, 2),
(87, '2024-03-21 11:55:43', 1, 3),
(88, '2024-03-21 11:55:44', 2, 5),
(89, '2024-03-21 11:55:44', 5, 3),
(90, '2024-03-21 11:55:44', 3, 2),
(91, '2024-03-21 11:55:44', 5, 7),
(92, '2024-03-21 11:55:44', 2, 5),
(93, '2024-03-21 11:55:44', 2, 4),
(94, '2024-03-21 11:55:45', 5, 6),
(95, '2024-03-21 11:55:45', 1, 3),
(96, '2024-03-21 11:55:45', 8, 9),
(97, '2024-03-21 11:55:46', 5, 6),
(98, '2024-03-21 11:55:46', 3, 2),
(99, '2024-03-21 11:55:46', 3, 2),
(100, '2024-03-21 11:55:47', 4, 5),
(101, '2024-03-21 11:55:47', 3, 2),
(102, '2024-03-21 11:55:47', 2, 4),
(103, '2024-03-21 11:55:48', 7, 5),
(104, '2024-03-21 11:55:48', 6, 8),
(105, '2024-03-21 11:55:48', 6, 8),
(106, '2024-03-21 11:55:49', 5, 3),
(107, '2024-03-21 11:55:49', 5, 3),
(108, '2024-03-21 11:55:49', 5, 3),
(109, '2024-03-21 11:55:49', 4, 5),
(110, '2024-03-21 11:55:49', 1, 3),
(111, '2024-03-21 11:55:50', 8, 9),
(112, '2024-03-21 11:55:50', 9, 7),
(113, '2024-03-21 11:55:50', 7, 5),
(114, '2024-03-21 11:55:50', 3, 2),
(115, '2024-03-21 11:55:51', 8, 9),
(116, '2024-03-21 11:55:51', 5, 3),
(117, '2024-03-21 11:55:52', 5, 3),
(118, '2024-03-21 11:55:52', 7, 5),
(119, '2024-03-21 11:55:52', 3, 2),
(120, '2024-03-21 11:55:52', 3, 2),
(121, '2024-03-21 11:55:52', 5, 6),
(122, '2024-03-21 11:55:52', 7, 5),
(123, '2024-03-21 11:55:52', 4, 5),
(124, '2024-03-21 11:55:52', 3, 2),
(125, '2024-03-21 11:55:53', 2, 5),
(126, '2024-03-21 11:55:53', 6, 8),
(127, '2024-03-21 11:55:53', 7, 5),
(128, '2024-03-21 11:55:53', 5, 3),
(129, '2024-03-21 11:55:53', 7, 5),
(130, '2024-03-21 11:55:53', 2, 5),
(131, '2024-03-21 11:55:53', 3, 2),
(132, '2024-03-21 11:55:54', 3, 2),
(133, '2024-03-21 11:55:54', 5, 6),
(134, '2024-03-21 11:55:55', 5, 7),
(135, '2024-03-21 11:55:55', 5, 7),
(136, '2024-03-21 11:55:55', 5, 6),
(137, '2024-03-21 11:55:55', 4, 5),
(138, '2024-03-21 11:55:55', 2, 4),
(139, '2024-03-21 11:55:55', 1, 2),
(140, '2024-03-21 11:55:56', 9, 7),
(141, '2024-03-21 11:55:56', 8, 9),
(142, '2024-03-21 11:55:56', 3, 2),
(143, '2024-03-21 11:55:56', 5, 7),
(144, '2024-03-21 11:55:56', 2, 5),
(145, '2024-03-21 11:55:57', 9, 7),
(146, '2024-03-21 11:55:57', 2, 5),
(147, '2024-03-21 11:55:58', 5, 6),
(148, '2024-03-21 11:55:58', 2, 5),
(149, '2024-03-21 11:55:58', 7, 5),
(150, '2024-03-21 11:55:58', 1, 2),
(151, '2024-03-21 11:55:59', 6, 8),
(152, '2024-03-21 11:55:59', 7, 5),
(153, '2024-03-21 11:55:59', 4, 5),
(154, '2024-03-21 11:55:59', 2, 5),
(155, '2024-03-21 11:56:00', 2, 5),
(156, '2024-03-21 11:56:00', 5, 3),
(157, '2024-03-21 11:56:00', 2, 5),
(158, '2024-03-21 11:56:00', 5, 7),
(159, '2024-03-21 11:56:01', 5, 7),
(160, '2024-03-21 11:56:01', 5, 7),
(161, '2024-03-21 11:56:01', 6, 8),
(162, '2024-03-21 11:56:01', 6, 8),
(163, '2024-03-21 11:56:01', 1, 2),
(164, '2024-03-21 11:56:01', 5, 7),
(165, '2024-03-21 11:56:01', 1, 3),
(166, '2024-03-21 11:56:02', 2, 4),
(167, '2024-03-21 11:56:02', 8, 9),
(168, '2024-03-21 11:56:02', 5, 7),
(169, '2024-03-21 11:56:02', 5, 6),
(170, '2024-03-21 11:56:03', 5, 3),
(171, '2024-03-21 11:56:03', 3, 2),
(172, '2024-03-21 11:56:03', 5, 7),
(173, '2024-03-21 11:56:03', 5, 3),
(174, '2024-03-21 11:56:03', 7, 5),
(175, '2024-03-21 11:56:04', 5, 6),
(176, '2024-03-21 11:56:04', 3, 2),
(177, '2024-03-21 11:56:05', 8, 10),
(178, '2024-03-21 11:56:05', 7, 5),
(179, '2024-03-21 11:56:05', 5, 3),
(180, '2024-03-21 11:56:05', 2, 4),
(181, '2024-03-21 11:56:05', 2, 5),
(182, '2024-03-21 11:56:06', 8, 10),
(183, '2024-03-21 11:56:06', 6, 8),
(184, '2024-03-21 11:56:06', 1, 3),
(185, '2024-03-21 11:56:06', 3, 2),
(186, '2024-03-21 11:56:06', 2, 4),
(187, '2024-03-21 11:56:06', 3, 2),
(188, '2024-03-21 11:56:06', 5, 6),
(189, '2024-03-21 11:56:07', 2, 5),
(190, '2024-03-21 11:56:07', 1, 2),
(191, '2024-03-21 11:56:07', 3, 2),
(192, '2024-03-21 11:56:08', 9, 7),
(193, '2024-03-21 11:56:08', 3, 2),
(194, '2024-03-21 11:56:08', 7, 5),
(195, '2024-03-21 11:56:08', 2, 4),
(196, '2024-03-21 11:56:09', 7, 5),
(197, '2024-03-21 11:56:09', 6, 8),
(198, '2024-03-21 11:56:09', 5, 3),
(199, '2024-03-21 11:56:10', 5, 7),
(200, '2024-03-21 11:56:10', 7, 5),
(201, '2024-03-21 11:56:10', 4, 5),
(202, '2024-03-21 11:56:10', 7, 5),
(203, '2024-03-21 11:56:10', 5, 7),
(204, '2024-03-21 11:56:11', 7, 5);

-- --------------------------------------------------------

--
-- Table structure for table `medicoesSalas`
--

CREATE TABLE `medicoesSalas` (
  `id_experiencia` int(11) NOT NULL,
  `sala` int(11) NOT NULL,
  `numero_ratos_final` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `medicoesTemperatura`
--

CREATE TABLE `medicoesTemperatura` (
  `id_medicao` int(11) NOT NULL,
  `hora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `leitura` decimal(4,2) NOT NULL,
  `sensor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parametrosadicionais`
--

CREATE TABLE `parametrosadicionais` (
  `id_experiencia` int(11) NOT NULL,
  `num_movimentos_ratos` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tipo_utilizador`
--

CREATE TABLE `tipo_utilizador` (
  `tipo_id` varchar(3) NOT NULL,
  `cargo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tipo_utilizador`
--

INSERT INTO `tipo_utilizador` (`tipo_id`, `cargo`) VALUES
('INV', 'Investigador');

-- --------------------------------------------------------

--
-- Table structure for table `utilizador`
--

CREATE TABLE `utilizador` (
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(12) NOT NULL,
  `tipo` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `utilizador`
--

INSERT INTO `utilizador` (`email`, `password`, `nome`, `telefone`, `tipo`) VALUES
('arthurcabrao91@aiesec.net', 'rumenaborim', 'Artur Cabral', '917863498', 'INV');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerta`
--
ALTER TABLE `alerta`
  ADD PRIMARY KEY (`id_alerta`);

--
-- Indexes for table `estados_experiencia`
--
ALTER TABLE `estados_experiencia`
  ADD PRIMARY KEY (`estado_id`),
  ADD KEY `estado_id` (`estado_id`);

--
-- Indexes for table `experiencia`
--
ALTER TABLE `experiencia`
  ADD PRIMARY KEY (`id_experiencia`),
  ADD KEY `utilizador_id_exp` (`investigador`),
  ADD KEY `estado_exp` (`estado_experiencia`);

--
-- Indexes for table `medicoesPassagens`
--
ALTER TABLE `medicoesPassagens`
  ADD PRIMARY KEY (`id_medicacao`);

--
-- Indexes for table `medicoesSalas`
--
ALTER TABLE `medicoesSalas`
  ADD PRIMARY KEY (`id_experiencia`,`sala`);

--
-- Indexes for table `medicoesTemperatura`
--
ALTER TABLE `medicoesTemperatura`
  ADD PRIMARY KEY (`id_medicao`);

--
-- Indexes for table `parametrosadicionais`
--
ALTER TABLE `parametrosadicionais`
  ADD PRIMARY KEY (`id_experiencia`);

--
-- Indexes for table `tipo_utilizador`
--
ALTER TABLE `tipo_utilizador`
  ADD PRIMARY KEY (`tipo_id`),
  ADD KEY `tipo_id` (`tipo_id`);

--
-- Indexes for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`email`),
  ADD KEY `email` (`email`),
  ADD KEY `tipo` (`tipo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `alerta`
--
ALTER TABLE `alerta`
  MODIFY `id_alerta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `experiencia`
--
ALTER TABLE `experiencia`
  MODIFY `id_experiencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `medicoesPassagens`
--
ALTER TABLE `medicoesPassagens`
  MODIFY `id_medicacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=205;

--
-- AUTO_INCREMENT for table `medicoesTemperatura`
--
ALTER TABLE `medicoesTemperatura`
  MODIFY `id_medicao` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `experiencia`
--
ALTER TABLE `experiencia`
  ADD CONSTRAINT `estado_exp` FOREIGN KEY (`estado_experiencia`) REFERENCES `estados_experiencia` (`estado_id`),
  ADD CONSTRAINT `utilizador_id_exp` FOREIGN KEY (`investigador`) REFERENCES `utilizador` (`email`);

--
-- Constraints for table `medicoesSalas`
--
ALTER TABLE `medicoesSalas`
  ADD CONSTRAINT `medicoes_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `experiencia` (`id_experiencia`);

--
-- Constraints for table `parametrosadicionais`
--
ALTER TABLE `parametrosadicionais`
  ADD CONSTRAINT `param_adic_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `experiencia` (`id_experiencia`);

--
-- Constraints for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD CONSTRAINT `utilizador_tipo` FOREIGN KEY (`tipo`) REFERENCES `tipo_utilizador` (`tipo_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
