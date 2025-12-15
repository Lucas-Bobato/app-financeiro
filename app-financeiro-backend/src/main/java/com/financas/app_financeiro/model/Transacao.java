package com.financas.app_financeiro.model;

import jakarta.persistence.*;
import java.math.BigDecimal; // Vamos usar para manipular valores monetários
import java.time.LocalDate; // Para representar datas

@Entity
@Table(name = "transacoes")

public class Transacao {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String descricao;

  private BigDecimal valor;

  @Enumerated(EnumType.STRING) // Salva no banco como String ("RECEITA", "DESPESA")
  private TipoTransacao tipo;

  private LocalDate data;

  // Relacionamento: Uma transação tem UMA categoria
  @ManyToOne
  @JoinColumn(name = "id_categoria") // Chave estrangeira para a tabela categoria
  private Categoria categoria;

  // Relacionamento: Uma transação pertence a UM usuário
  @ManyToOne
  @JoinColumn(name = "id_usuario") // Chave estrangeira para a tabela usuário
  private Usuario usuario;

  // Inicializador vazio (necessário para JPA)
  public Transacao() {}

  // Getters e Setters
  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }

  public String getDescricao() { return descricao; }
  public void setDescricao(String descricao) { this.descricao = descricao; }

  public BigDecimal getValor() { return valor; }
  public void setValor(BigDecimal valor) { this.valor = valor; }

  public TipoTransacao getTipo() { return tipo; }
  public void setTipo(TipoTransacao tipo) { this.tipo = tipo; }

  public LocalDate getData() { return data; }
  public void setData(LocalDate data) { this.data = data; }

  public Categoria getCategoria() { return categoria; }
  public void setCategoria(Categoria categoria) { this.categoria = categoria; }

  public Usuario getUsuario() { return usuario; }
  public void setUsuario(Usuario usuario) { this.usuario = usuario; }
}
