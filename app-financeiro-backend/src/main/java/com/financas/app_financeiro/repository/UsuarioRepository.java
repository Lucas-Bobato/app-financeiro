package com.financas.app_financeiro.repository;

import com.financas.app_financeiro.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {
  // Usa o estender do JpaRepository, para ganhae métodos como:
  // .save(), .findById(), .findAll(), .delete()

  // Permite a criação de buscas personalizadas, ex:
  // Usuario findByEmail(String email);
  
  // Método para autenticação
  Usuario findByEmailAndSenha(String email, String senha);
  
  // Método para verificar se email já existe
  boolean existsByEmail(String email);

}
