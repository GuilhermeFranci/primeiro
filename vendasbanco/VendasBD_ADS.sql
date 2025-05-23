-------------------------------------------------------------------------------
-- CRIAR O BANCO DE DADOS
-------------------------------------------------------------------------------
create database VendasBD_ADS
go

-------------------------------------------------------------------------------
-- ACESSAR O BANCO DE DADOS
-------------------------------------------------------------------------------
use VendasBD_ADS
go


-------------------------------------------------------------------------------
-- CRIAR A TABELA PESSOAS
------------------------------------------------------------------------------- 
create table Pessoas(
	idPessoa		int				not null	primary key				identity,
	nome			varchar(50)		not null,
	cpf				varchar(14)		not null	unique,
	status			int					null	check(status in(1,2)) -- Restrição de stauts 1-ativo | 2-Inativo
)
go

-------------------------------------------------------------------------------
-- CRIAR A TABELA CLIENTES
-------------------------------------------------------------------------------
create table Clientes(
	pessoaId	int				not null	primary key					references Pessoas(idPessoa),
	renda		decimal(10,2)	not null	check(renda >= 700.00),
	credito		decimal(10,2)	not null	check(credito >= 100.00)
)
go

-------------------------------------------------------------------------------
-- CRIAR A TABELA VENDEDORES
-------------------------------------------------------------------------------
create table Vendedores(
	pessoaId	int				not null	primary key					references Pessoas(idPessoa),
	salario		decimal(10,2)	not null	check(salario >= 1000.00)
)
go


-------------------------------------------------------------------------------
-- CRIAR A TABELA PEDIDOS
-------------------------------------------------------------------------------
create table Pedidos(
	idPedido	int				not null	primary key					identity,
	data		datetime		not null,
	valor		decimal(10,2)		null,
	status		int					null	check(status in(1,2,3)),	-- 1-Em andamento | 2-Finalizado | 3-Entregue
	vendedorId	int				not null	references Vendedores(pessoaId),
	clienteId	int				not null	references Clientes(pessoaId)
)
go

-------------------------------------------------------------------------------
-- CRIAR A TABELA PRODUTOS
-------------------------------------------------------------------------------
create table Produtos(
	idProduto	int				not null	primary key					identity,
	descricao	varchar(100)	not null,
	qtd			int					null	check(qtd >= 0),
	valor		decimal(10,2)		null	check(valor >= 0.0),
	status		int					null	check(status in(1,2))
)
go

-------------------------------------------------------------------------------
-- CRIAR A TABELA ITENS_PEDIDOS (NxN)
-------------------------------------------------------------------------------
create table ItensProdutos(
	pedidoId	int				not null	references Pedidos(idPedido),
	produtoId	int				not null	references Produtos(idProduto),
	qtd			int					null	check(qtd > 0),
	valor		decimal(10,2)		null	check(valor > 0),
	primary key(pedidoId, produtoId)
)
go

-------------------------------------------------------------------------------
-- CONSULTAR O DICIONÁRIO DE DADOS
-------------------------------------------------------------------------------
sp_help Produtos
go


-------------------------------------------------------------------------------
-- CADASTRAR 10 PESSOAS
-------------------------------------------------------------------------------
insert into Pessoas (nome, cpf, status)
values		('Lucas Cagao', '000.000.000-00', 1),
			('Carlos Magnus Carlson Filho', '010.010.010-00', 2),
			('Guilherme Francisco', '110.110.110-11', null),
			('Yago', '200.000.000-00', 1),
			('wigny tem o molho', '210.010.010-00', 2),
			('Eduardo Capatti', '110.110.110-13', 2),
			('jonas o sabio', '110.110.120-11', null),
			('jorge Matheus', '200.000.000-20', 1),
			('gatinho da mamãe', '210.010.310-00', null),
			('lucas mia', '130.120.110-13', 2)
go

select * from Pessoas
go


-------------------------------------------------------------------------------
-- CADASTRAR 4 CLIENTES E 3 VENDEDORES
-------------------------------------------------------------------------------
insert into Clientes(pessoaId, renda, credito)
values		(2, 5000.00, 1500.00),
			(6, 5500.00, 1750.00),
			(8, 3500.00, 1250.00),
			(10, 7500.00, 3200.00)
go

select * from Clientes
go

insert into Vendedores(pessoaId, salario)
values		(1, 4500.00),
			(5, 6500.00),
			(7, 1500.00)
go

select * from Vendedores
go

insert into Produtos(descricao, qtd, valor, status)
values	('Chocolate ao leite', 50, 10.50, 1), 
		('Sorvete de Chocolate', 12, 15.75, 2), 
		('Bolo de Chocolate', 20, 35.20, 1), 
		('Bolo de milho', 30, 25.50, 1), 
		('Pipoca Doce', 150, 2.50, 1), 
		('Cocada Branca', 200, 3.50, null), 
		('Pacocao', 150, 5.50,1), 
		('Amendoin Salgado', 100, 4.50, null),
		('Bolo de Cenoura', 40, 22.30, 1),
		('Gelatina de Frutas', 80, 4.00, 1),
		('Pudim de Leite Condensado', 25, 20.00, 1),
		('Mousse de Maracujá', 35, 18.50, 1),
		('Biscoito de Polvilho', 120, 7.80, 1),
		('Pão de Queijo', 200, 12.00, 1),
		('Torta de Limão', 15, 30.00, 2),
		('Coxinha de Frango', 90, 6.50, 1),
		('Pastel de Carne', 60, 8.30, 1),
		('Churros', 110, 4.20, 1),
		('Salgadinho de Milho', 250, 1.80, null),
		('Bolinhos de Arroz', 130, 5.90, 1),
		('Torta de Frango', 45, 28.50, 1),
		('Quindim', 55, 13.00, 1),
		('Geladinho de Morango', 200, 3.80, null),
		('Brigadeiro', 500, 2.00, 1)
go

select * from Produtos
go

-------------------------------------------------------------------------------
-- CADASTRAR 7 PEDIDOS
-------------------------------------------------------------------------------
insert into Pedidos(data, status, vendedorId, clienteId)
values		('2025-04-01', 1, 1, 2),
			(GETDATE(), 2, 5, 2),
			('2025-02-11', 1, 1, 8),
			('2025-07-09', 1, 7, 10),
			(GETDATE(), 1, 5, 8),
			('2024-04-01', 2, 1, 6),
			(GETDATE(), null, 1, 2)
go


-------------------------------------------------------------------------------
-- ITENS PEDIDO 1
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(8, 24, 5, 2.00),
			(8, 23, 2, 13.00),
			(8, 22, 1, 3.80)
go

-------------------------------------------------------------------------------
-- ITENS PEDIDO 2
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(9, 1, 5, 10.50),
			(9, 2, 2, 15.75)
go

-------------------------------------------------------------------------------
-- ITENS PEDIDO 3
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(10, 9, 3, 22.30)
go

-------------------------------------------------------------------------------
-- ITENS PEDIDO 4
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(4, 4, 2, 25.50),
			(4, 5, 10, 2.50)
go

-------------------------------------------------------------------------------
-- ITENS PEDIDO 5
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(5, 7, 5, 5.50),
			(5, 10, 2, 4.00)
go

-------------------------------------------------------------------------------
-- ITENS PEDIDO 6
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(6, 14, 2, 12.00),
			(6, 15, 8, 30.00),
			(6, 16, 6, 6.50)
go

-------------------------------------------------------------------------------
-- ITENS PEDIDO 7
-------------------------------------------------------------------------------
insert into ItensProdutos (pedidoId, produtoId, qtd, valor)
values		(7, 17, 50, 8.30),
			(7, 18, 20, 4.20),
			(7, 19, 12, 1.80)
go















