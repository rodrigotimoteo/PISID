CREATE TABLE `experiencia` (
  `id_experiencia` integer PRIMARY KEY AUTO_INCREMENT,
  `descricao` text,
  `investigador` varchar(50) NOT NULL,
  `datahora` timestamp NOT NULL,
  `numero_ratos` int NOT NULL,
  `limite_ratos_sala` int NOT NULL,
  `segundos_sem_movimento` int NOT NULL,
  `temperatura_ideal` decimal(4,2) NOT NULL,
  `variacao_temperatura_maxima` decimal(4,2) NOT NULL
);

CREATE TABLE `utilizador` (
  `email` varchar(50) PRIMARY KEY NOT NULL,
  `password` varchar(255) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `telefone` varchar(12) NOT NULL,
  `tipo` varchar(3) NOT NULL
);

CREATE TABLE `medicoesPassagens` (
  `id_medicacao` integer PRIMARY KEY AUTO_INCREMENT,
  `hora` timestamp NOT NULL,
  `sala_origem` integer NOT NULL,
  `sala_destino` integer NOT NULL
);

CREATE TABLE `medicoesTemperatura` (
  `id_medicao` integer PRIMARY KEY AUTO_INCREMENT,
  `hora` timestamp NOT NULL,
  `leitura` decimal(4,2) NOT NULL,
  `sensor` integer NOT NULL
);

CREATE TABLE `alerta` (
  `id_alerta` integer PRIMARY KEY AUTO_INCREMENT,
  `hora` timestamp NOT NULL,
  `sala` integer NOT NULL,
  `sensor` integer NOT NULL,
  `leitura` decimal(4,2) NOT NULL,
  `tipo_alerta` varchar(20) NOT NULL,
  `mensagem` varchar(100),
  `hora_escrita` timestamp NOT NULL
);

CREATE TABLE `medicoesSalas` (
  `id_experiencia` integer,
  `sala` integer,
  `numero_ratos_final` integer NOT NULL,
  PRIMARY KEY (`id_experiencia`, `sala`)
);

CREATE TABLE `parametrosadicionais` (
  `id_experiencia` integer PRIMARY KEY,
  `num_movimentos_ratos` integer
);

ALTER TABLE `medicoesSalas` ADD CONSTRAINT `medicoes_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `experiencia` (`id_experiencia`);

ALTER TABLE `parametrosadicionais` ADD CONSTRAINT `param_adic_id_exp` FOREIGN KEY (`id_experiencia`) REFERENCES `experiencia` (`id_experiencia`);

ALTER TABLE `experiencia` ADD CONSTRAINT `utilizador_id_exp` FOREIGN KEY (`investigador`) REFERENCES `utilizador` (`email`);
