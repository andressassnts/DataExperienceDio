-- criação do banco de dados para o cenário de E-commerce --
create database ecommerce;

use ecommerce;

-- criar tabela cliente
create table cliente(
idCliente int auto_increment primary key,
nome varchar(30),
cpf char(11)  not null,
constraint unique_cpf_cliente unique (cpf),
endereco varchar(30),
datanascimento date
);

-- criar tabela produto
create table produto(
idProduto int auto_increment primary key,
descricao varchar(30) not null,
categoria ENUM('eletronico', 'brinquedo', 'alimento', 'vestuario'),
valor float
);

-- criar tabela pagamento
create table pagamento(
idPagamento int auto_increment primary key,
idPagCliente int,
tipoPag ENUM('boleto', 'cartão', 'pix', 'debito') not null,
constraint fk_pagamento_cliente foreign key (idPagCliente) references cliente(idCliente)
);

-- criar tabela pedido
create table pedido(
idPedido int auto_increment primary key,
idPedidoCliente int,
idPedidoPagam int,
statusPedido ENUM('em andamento', 'processando', 'enviado', 'entregue','cancelado') not null,
descricao varchar(30),
frete float default 0,
pagamento bool default false,
constraint fk_pedido_cliente foreign key (idPedidoCliente) references cliente(idCliente),
constraint fk_pedido_pagamento foreign key (idPedidoPagam) references pagamento(idPagamento)
);

-- criar tabela estoque
create table estoque(
idEstoque int auto_increment primary key,
localEstoque varchar(30),
quantidade int default 0
);

-- criar tabela fornecedor
create table fornecedor(
idFornecedor int auto_increment primary key,
razaoSocial varchar(30),
cnpj char(15),
contato char(11),
constraint unique_cnpj_fornecedor unique (cnpj)
);

-- criar tabela terceiro
create table terceiro(
idTerceiro int auto_increment primary key,
razaoSocial varchar(30),
cnpj char(15),
localTerceiro varchar(45),
contato char(11),
cpf char(11),
constraint unique_cnpj_terceiro unique (cnpj),
constraint unique_cpf_terceiro unique (cpf)
);


-- criar tabela terceiroProd  ligação de produto e terceiro
create table terceiroProd(
idPterceiro int,
idProdutoTer int,
quantidade int default 1,
primary key(idPterceiro, idProdutoTer),
constraint fk_produto_terceiro foreign key (idPterceiro) references terceiro(idTerceiro),
constraint fk_produto_produto foreign key (idProdutoTer) references produto(idProduto)
);

-- criar tabela PedidoProd  ligação de produto e pedido
create table PedidoProd(
idPedidoPr int,
idProdutoPed int,
quantidade int default 1,
statusEst ENUM('disponivel', 'fora de estoque') default 'disponivel',
primary key(idPedidoPr, idProdutoPed),
constraint fk_produto_pedido foreign key (idPedidoPr) references pedido(idPedido),
constraint fk_pedido_produto foreign key (idProdutoPed) references produto(idProduto)
);

-- criar tabela EstoqueProd ligação de produto e estoque
create table EstoqueProd(
idEstoquePr int,
idProdutoEst int,
quantidade int default 0,
primary key(idEstoquePr, idProdutoEst),
constraint fk_produto_estoque foreign key (idEstoquePr) references estoque(idEstoque),
constraint fk_estoque_produto foreign key (idProdutoEst) references produto(idProduto)
);

-- criar tabela FornecedorProd ligação de produto e fornecedor
create table fornecedorProd(
idFornecedorPr int,
idProdutoFor int,
quantidade int default 0,
primary key(idFornecedorPr, idProdutoFor ),
constraint fk_produto_fornecedor foreign key (idFornecedorPr) references fornecedor(idFornecedor),
constraint fk_fornecedor_produto foreign key (idProdutoFor) references produto(idProduto)
);

-- criar tabela Entrega
create table Entrega(
idEntrega int auto_increment primary key,
idPedidoEnt int,
rastrio varchar(20),
statusEst ENUM('em andamento', 'caminho', 'entregue', 'retornou loja') default 'em andamento',
constraint fk_entrega_pedido foreign key (idPedidoEnt) references pedido(idPedido)
);


