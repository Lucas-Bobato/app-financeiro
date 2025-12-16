package com.financas.app_financeiro.repository;

import com.financas.app_financeiro.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    // Buscar categorias de um usuário específico
    List<Categoria> findByUsuarioId(Long usuarioId);
    
    // Buscar categorias padrão (sem usuário)
    List<Categoria> findByUsuarioIsNull();
}