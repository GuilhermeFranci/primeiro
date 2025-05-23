-------------------------------------------------------------------------------
-- TIPOS DE JOIN
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- ACESSAR O BANCO DE DADOS
-------------------------------------------------------------------------------
use VendasBD_ADS

-------------------------------------------------------------------------------
-- INNER JOIN
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 1) Consultar todas as pessoas que são clientes
-- Saída: id, nome, cpf da pessoa, a renda e crédito do cliente
-------------------------------------------------------------------------------
-- inner join
select P.idPessoa as Cod_Cliente, P.nome as Cliente, P.cpf as CPF, C.renda as Renda, C.credito as Credito
from Pessoas P inner join  Clientes C
on P.idPessoa = C.pessoaId
go

-- where
select P.idPessoa as Cod_Cliente, P.nome as Cliente, P.cpf as CPF, C.renda as Renda, C.credito as Credito
from Pessoas P, Clientes C
where P.idPessoa = C.pessoaId
go

-------------------------------------------------------------------------------
-- 2) Consultar todas as pessoas que são clientes
-- Saída: id, nome, cpf da pessoa, a renda e crédito do cliente, ordenada pelo
-- nome e que tenha renda acima de 3500.00
-------------------------------------------------------------------------------
select P.idPessoa as Cod_Cliente, P.nome as Cliente, P.cpf as CPF, C.renda as Renda, C.credito as Credito
from Pessoas as P inner join Clientes C
on P.idPessoa = C.pessoaId
where C.renda > 3500.00
order by P.nome
go

-- sem where
select P.idPessoa as Cod_Cliente, P.nome as Cliente, P.cpf as CPF, C.renda as Renda, C.credito as Credito
from Pessoas as P inner join Clientes C
on P.idPessoa = C.pessoaId and C.renda > 3500.00
order by P.nome
go
-------------------------------------------------------------------------------
-- 3) Consultar todas as pessoas que são vendedores
-- Saída: id, nome, cpf da pessoa, o salario do vendedor
-------------------------------------------------------------------------------
Select  P.idPessoa as Cod_Vendedor, P.nome as Vendedor, P.cpf as CPF, V.salario As [Salario vendedor]
from Pessoas P Inner join Vendedores V
on V.pessoaId = P.idPessoa
go
-------------------------------------------------------------------------------
-- 4) Consultar os pedidos de cada cliente 
-- Saída: id, nome, cpf da pessoa e renda do cliente, id, data, status do pedido
-------------------------------------------------------------------------------
select P.idPessoa Cod_cliente, P.nome Cliente, P.cpf, C.renda Renda,PE.idPedido as No_pedido, Pe.data Data_pedido, PE.status Situacao
from Pessoas as P inner join Clientes C
on P.idPessoa = C.pessoaId inner join Pedidos PE
on P.idPessoa = PE.clienteId
order by P.idPessoa
go

-------------------------------------------------------------------------------
-- 5) Consultar os pedidos gerados pelos vendedores 
-- Saída: id, nome, cpf e salario do vendedor, id, data, status do pedido
-- id do cliente que fez o pedido
-------------------------------------------------------------------------------
select P.idPessoa, P.nome, P.cpf, V.salario, PE.idPedido, PE.data, PE.status
from Pessoas P inner join Vendedores V 
on P.idPessoa = V.pessoaId inner join Pedidos PE 
on P.idPessoa = PE.vendedorId
order by P.idPessoa
go

-------------------------------------------------------------------------------
-- 6) Consultar os produtos que compoem os pedidos
-- Saída: id, data, status dos pedidos, id, descricao, qtd vendida, valor pago
-- dos produtos de cada pedido
-------------------------------------------------------------------------------
select P.idPedido, P.data, IP.produtoId, PR.descricao, IP.qtd, IP.valor,
		case P.status
			when 1 then 'em andamento'
			when 2 then 'finalizado'
			when 3 then 'entregue'
			else 'cancelado'
		end Situacao_pedido
from Pedidos P inner join ItensProdutos IP
on P.idPedido = IP.pedidoId inner join Produtos PR
on PR.idProduto = IP.produtoId
go

-------------------------------------------------------------------------------
-- 7) Consultar todos os pedidos e trazer o total calculado de cada um deles
-- Saída: id, data, total e status de cada pedido
-------------------------------------------------------------------------------
select P.idPedido, P.data, SUM(IP.valor * IP.qtd) Total, 
		case P.status
			when 1 then 'em andamento'
			when 2 then 'finalizado'
			when 3 then 'entregue'
			else 'cancelado'
		end Situacao_pedido
from Pedidos P inner join ItensProdutos IP
on P.idPedido = IP.pedidoId
group by P.idPedido, P.data, P.status
go

-------------------------------------------------------------------------------
-- 8) Consultar todos os produtos e trazer a quantidade vendida de cada um deles
-- Saída: id, descricao, total de qtd vendida de todos os produtos
-------------------------------------------------------------------------------
select P.idProduto, P.descricao, SUM(IP.qtd) [Total Vendida]
from Produtos P inner join ItensProdutos IP
on P.idProduto = IP.produtoId
group by P.idProduto, P.descricao
go


-------------------------------------------------------------------------------
-- 9) melhorar a consulta anterior trazendo o valor total de venda de cada produto
-------------------------------------------------------------------------------
select P.idProduto, P.descricao, SUM(IP.qtd) [Total Vendida], SUM(IP.valor * IP.qtd) Total, P.valor
from Produtos P inner join ItensProdutos IP
on P.idProduto = IP.produtoId
group by P.idProduto, P.descricao, P.valor
go



-------------------------------------------------------------------------------
-- LEFT JOIN
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- 1) Consultar todas as pessoas que são clientes ou não
-- Saída: id, nome, cpf, status da pessoa, renda e crédito do cliente
-------------------------------------------------------------------------------
select P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf, C.renda Renda, C.credito Crédito,
	   case P.status
			when 1 then 'Ativo'
			when 2 then 'Inativo'
			else 'Cancelado'
	   end Situacao
from Pessoas P left join Clientes C
on	P.idPessoa = C.pessoaId
go

-------------------------------------------------------------------------------
-- 2) Consultar todas as pessoas que são vendedores ou não
-- Saída: id, nome, cpf, status da pessoa, salario do vendedor
-------------------------------------------------------------------------------
select  P.idPessoa, P.nome, P.cpf, V.salario,
		case P.status
			when 1 then 'Ativo'
			when 2 then 'Inativo'
			else 'Cancelado'
		end Situacao
from Pessoas P left join Vendedores V
on P.idPessoa = V.pessoaId
go

-------------------------------------------------------------------------------
-- 3) Consultar todas as pessoas que são clientes e que fizeram ou não pedido
-- Saída: id, nome, renda do cliente, no., data, status do pedido
-- Objetivo: usar inner join com left join
-------------------------------------------------------------------------------
select P.idPessoa Cod_Cliente, P.nome Cliente, C.renda Renda, PE.idPedido No_Pedido, Pe.data Data_Pedido, 
		case Pe.status
			when 1 then 'em andamento'
			when 2 then 'Finalizado'
			when 3 then 'Entregue'
			else 'Cancelado'
		end Situacao_Pedido
from Pessoas P inner join Clientes C
on P.idPessoa = C.pessoaId left join Pedidos PE
on C.pessoaId = PE.clienteId
go
