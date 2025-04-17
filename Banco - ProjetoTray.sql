CREATE SCHEMA IF NOT EXISTS ProjetoTray DEFAULT CHARACTER SET utf8;
USE ProjetoTray;

-- -----------------------------------------------------
-- Tabela tipo (tipo de login, se é funcionario ou cliente)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.tipo (
  idTipo INT NOT NULL AUTO_INCREMENT,
  nomeTipo VARCHAR(45) NOT NULL,
  PRIMARY KEY (idTipo));

-- -----------------------------------------------------
-- Tabela login
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.login (
  idLogin INT NOT NULL AUTO_INCREMENT,
  emailLogin VARCHAR(45) NOT NULL,
  senhaLogin VARCHAR(45) NOT NULL,
  tipo_idTipo INT NOT NULL, -- Recebe da tabela tipo
  PRIMARY KEY (idLogin),
  INDEX fk_login_tipo1_idx (tipo_idTipo ASC) VISIBLE,
  CONSTRAINT fk_login_tipo1
    FOREIGN KEY (tipo_idTipo)
    REFERENCES ProjetoTray.tipo (idTipo)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela de funcionários
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.funcionario (
  idFunc INT NOT NULL AUTO_INCREMENT,
  nomeFunc VARCHAR(45) NOT NULL,
  cargoFunc VARCHAR(45) NOT NULL,
  login_idLogin INT NOT NULL, -- Recebe seu id de login
  PRIMARY KEY (idFunc),
  INDEX fk_funcionario_login1_idx (login_idLogin ASC) VISIBLE,
  CONSTRAINT fk_funcionario_login1
    FOREIGN KEY (login_idLogin)
    REFERENCES ProjetoTray.login (idLogin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.cliente (
  idCli INT NOT NULL AUTO_INCREMENT,
  nomeCli VARCHAR(45) NOT NULL,
  empresaCli VARCHAR(45) NOT NULL,
  telefoneCli VARCHAR(45) NOT NULL,
  login_idLogin INT NOT NULL, -- Recebe seu id de login
  PRIMARY KEY (idCli),
  INDEX fk_cliente_login1_idx (login_idLogin ASC) VISIBLE,
  CONSTRAINT fk_cliente_login1
    FOREIGN KEY (login_idLogin)
    REFERENCES ProjetoTray.login (idLogin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela de projetos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.projeto (
  idProj INT NOT NULL AUTO_INCREMENT,
  nomeProj VARCHAR(45) NOT NULL,
  descProj VARCHAR(100) NOT NULL,
  PRIMARY KEY (idProj));

-- -----------------------------------------------------
-- Tabela de notificações
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.notificacao (
  idNot INT NOT NULL AUTO_INCREMENT,
  assuntoNot VARCHAR(45) NOT NULL,
  conteudoNot VARCHAR(200) NOT NULL,
  remetenteNot INT NOT NULL, -- Vai salvar o id de quem enviou
  PRIMARY KEY (idNot),
  INDEX fk_notificacao_login1_idx (remetenteNot ASC) VISIBLE,
  CONSTRAINT fk_notificacao_login1
    FOREIGN KEY (remetenteNot)
    REFERENCES ProjetoTray.login (idLogin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela entre funcionário e projeto (pois um funcionário pode estar em vários projetos e um projeto pode ter vários funcionários)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.funcionario_has_projeto (
  funcionario_idFunc INT NOT NULL,
  projeto_idProj INT NOT NULL,
  PRIMARY KEY (funcionario_idFunc, projeto_idProj),
  INDEX fk_funcionario_has_projeto_projeto1_idx (projeto_idProj ASC) VISIBLE,
  INDEX fk_funcionario_has_projeto_funcionario1_idx (funcionario_idFunc ASC) VISIBLE,
  CONSTRAINT fk_funcionario_has_projeto_funcionario1
    FOREIGN KEY (funcionario_idFunc)
    REFERENCES ProjetoTray.funcionario (idFunc)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_funcionario_has_projeto_projeto1
    FOREIGN KEY (projeto_idProj)
    REFERENCES ProjetoTray.projeto (idProj)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela entre cliente e projeto (pois um cliente pode ter vários projetos e um projeto pode ter vários cliente)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.cliente_has_projeto (
  cliente_idCli INT NOT NULL,
  projeto_idProj INT NOT NULL,
  PRIMARY KEY (cliente_idCli, projeto_idProj),
  INDEX fk_cliente_has_projeto_projeto1_idx (projeto_idProj ASC) VISIBLE,
  INDEX fk_cliente_has_projeto_cliente1_idx (cliente_idCli ASC) VISIBLE,
  CONSTRAINT fk_cliente_has_projeto_cliente1
    FOREIGN KEY (cliente_idCli)
    REFERENCES ProjetoTray.cliente (idCli)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_cliente_has_projeto_projeto1
    FOREIGN KEY (projeto_idProj)
    REFERENCES ProjetoTray.projeto (idProj)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela das colunas dos projetos
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.coluna (
  idCol INT NOT NULL AUTO_INCREMENT,
  nomeCol VARCHAR(45) NOT NULL,
  PRIMARY KEY (idCol));

-- -----------------------------------------------------
-- Tabela das tarefas que ficam nas colunas
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.tarefa (
  idTarefa INT NOT NULL AUTO_INCREMENT,
  nomeTarefa VARCHAR(45) NOT NULL,
  descTarefa VARCHAR(100) NULL,
  PRIMARY KEY (idTarefa));

-- -----------------------------------------------------
-- Tabela entre coluna, projeto e tarefa (pois uma coluna (que pode estar em vários projetos) pode ter várias tarefas e um tarefa (que pode estar em várias colunas), com o mesmo nome, pode estar em várias colunas)
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.coluna_has_projeto_has_tarefa (
  coluna_idCol INT NOT NULL,
  projeto_idProj INT NOT NULL,
  tarefa_idTarefa INT NOT NULL,
  PRIMARY KEY (coluna_idCol, projeto_idProj, tarefa_idTarefa),
  INDEX fk_coluna_has_projeto_projeto1_idx (projeto_idProj ASC) VISIBLE,
  INDEX fk_coluna_has_projeto_coluna1_idx (coluna_idCol ASC) VISIBLE,
  INDEX fk_coluna_has_projeto_tarefa1_idx (tarefa_idTarefa ASC) VISIBLE,
  CONSTRAINT fk_coluna_has_projeto_coluna1
    FOREIGN KEY (coluna_idCol)
    REFERENCES ProjetoTray.coluna (idCol)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_coluna_has_projeto_projeto1
    FOREIGN KEY (projeto_idProj)
    REFERENCES ProjetoTray.projeto (idProj)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_coluna_has_projeto_tarefa1
    FOREIGN KEY (tarefa_idTarefa)
    REFERENCES ProjetoTray.tarefa (idTarefa)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Tabela de destinatário das notificações
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ProjetoTray.destinatario (
  notificacao_idNot INT NOT NULL, -- id da notificação que o destinatário vai receber
  login_idLogin INT NOT NULL, -- id de quem vai receber
  PRIMARY KEY (notificacao_idNot, login_idLogin),
  INDEX fk_notificacao_has_login_login1_idx (login_idLogin ASC) VISIBLE,
  INDEX fk_notificacao_has_login_notificacao1_idx (notificacao_idNot ASC) VISIBLE,
  CONSTRAINT fk_notificacao_has_login_notificacao1
    FOREIGN KEY (notificacao_idNot)
    REFERENCES ProjetoTray.notificacao (idNot)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_notificacao_has_login_login1
    FOREIGN KEY (login_idLogin)
    REFERENCES ProjetoTray.login (idLogin)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);





-- -----------------------------------------------------
-- Valores pré-setados
-- -----------------------------------------------------
INSERT INTO tipo (nomeTipo) VALUES ("funcionario"), ("cliente");

INSERT INTO login (emailLogin, senhaLogin, tipo_idTipo) VALUES 
("email@teste.com", "1234", 1),
("email2@teste.com", "5678", 1),
("email3@teste.com", "9012", 2),
("email4@teste.com", "3456", 2);

INSERT INTO funcionario (nomeFunc, cargoFunc, login_idLogin) VALUES
("Cleiton", "Desenvolvedor Junior", 1),
("Mateus", "Engenheiro de Software", 2);

INSERT INTO cliente (nomeCli, empresaCli, telefoneCli, login_idLogin) VALUES
("Rodolfo", "Varejo Marília", "14999990000", 3),
("Lucas", "Lojas Giga", "15000002222", 4);

INSERT INTO projeto (nomeProj, descProj) VALUES
("E-commerce Lojas Giga", "Site para vendas online"),
("E-commerce Varejo Marília", "Melhoria do último projeto");

INSERT INTO notificacao (assuntoNot, conteudoNot, remetenteNot) VALUES
("Modificações", "Adicionei mudanças que gostaria que fizessem no meu site", 3),
("Remoção", "Não gostei de algumas coisas que adicionaram, não combina com meu trabalho, segue mudanças", 4);

INSERT INTO funcionario_has_projeto (funcionario_idFunc, projeto_idProj) VALUES
(1, 1),
(2, 1),
(2, 2);

INSERT INTO cliente_has_projeto (cliente_idCli, projeto_idProj) VALUES
(1, 2),
(2, 1);

INSERT INTO coluna (nomeCol) VALUES
("Alinhamento"),
("Fase 1");

INSERT INTO tarefa (nomeTarefa, descTarefa) VALUES
("Diagramação", "Fazer diagramas para o desenvolvimento do site"),
("Fazer classes", "Implementar as classes previstas");

INSERT INTO coluna_has_projeto_has_tarefa (coluna_idCol, projeto_idProj, tarefa_idTarefa) VALUES
(1, 1, 1),
(1, 2, 1),
(2, 1, 2),
(2, 2, 2);

INSERT INTO destinatario (notificacao_idNot, login_idLogin) VALUES
(1, 1),
(1, 2),
(2, 2);