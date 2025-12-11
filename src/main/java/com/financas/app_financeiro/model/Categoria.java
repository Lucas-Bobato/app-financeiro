package com.financas.app_financeiro.model;

import jakarta.persistence.*;

@Entity
@Table(name = "categorias")

public class Categoria {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String nome;

  // Relacionamento: Muitas Categorias para um Usuário

  @ManyToOne
  @JoinColumn(name = "usuario_id") // Nome da coluna no banco
  private Usuario usuario;
  // Se o 'usuario' for null, é uma categoria padrão.

  // Construtor Vazio (O JPA precisa disso)
  public Categoria() {}

  // Getters e Setters
  public Long getId() { return id; }
  public void setId(Long id) { this.id = id; }

  public String getNome() { return nome; }
  public void setNome(String nome) { this.nome = nome; }

  public Usuario getUsuario() { return usuario; }
  public void setUsuario(Usuario usuario) { this.usuario = usuario; }
}