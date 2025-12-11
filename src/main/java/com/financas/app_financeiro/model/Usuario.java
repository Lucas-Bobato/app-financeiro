package com.financas.app_financeiro.model;

import jakarta.persistence.*;

@Entity
@Table(name = "usuarios")

public class Usuario {
  @Id // Diz que este é o ID único
  @GeneratedValue(strategy = GenerationType.IDENTITY) // O banco gera o ID automaticmamente
  private long id;

  private String nome;
  private String email;
  private String senha;

  @Enumerated(EnumType.STRING) // Salva no banco como String ("FREE", "PREMIUM")
  private TipoPlano tipoPlano;

  // Construtor Vazio (O JPA precisa disso)
  public Usuario() {}

  // Getters e Setters
  public long getId() {return id; }
  public void setID(long id) { this.id = id; }

  public String getNome() { return nome; }
  public void setNome(String nome) { this.nome = nome; }

  public String getEmail() { return email; }
  public void setEmail(String email) { this.email = email; }

  public String getSenha() { return senha; }
  public void setSenha(String senha) { this.senha = senha; }

  public TipoPlano getTipoPlano() { return tipoPlano; }
  public void setTipoPlano(TipoPlano tipoPlano) { this.tipoPlano = tipoPlano; }
}
