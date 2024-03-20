-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Mar 20, 2024 at 09:44 PM
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
-- Table structure for table `experiencia`
--

CREATE TABLE `experiencia` (
  `id_experiencia` int(11) NOT NULL,
  `descricao` text DEFAULT NULL,
  `investigador` varchar(50) NOT NULL,
  `datahora` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `numero_ratos` int(11) NOT NULL,
  `limite_ratos_sala` int(11) NOT NULL,
  `segundos_sem_movimento` int(11) NOT NULL,
  `temperatura_ideal` decimal(4,2) NOT NULL,
  `variacao_temperatura_maxima` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(18, '2024-03-20 20:35:26', 2, 4);

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
('arthurcabrao91@aiesec.net', 'rumenaborim', 'Arthur Cabral', '917863498', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `alerta`
--
ALTER TABLE `alerta`
  ADD PRIMARY KEY (`id_alerta`);

--
-- Indexes for table `experiencia`
--
ALTER TABLE `experiencia`
  ADD PRIMARY KEY (`id_experiencia`),
  ADD KEY `utilizador_id_exp` (`investigador`);

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
-- Indexes for table `utilizador`
--
ALTER TABLE `utilizador`
  ADD PRIMARY KEY (`email`),
  ADD KEY `email` (`email`);

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
  MODIFY `id_experiencia` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `medicoesPassagens`
--
ALTER TABLE `medicoesPassagens`
  MODIFY `id_medicacao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
