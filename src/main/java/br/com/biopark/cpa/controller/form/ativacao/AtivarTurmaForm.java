package br.com.biopark.cpa.controller.form.ativacao;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class AtivarTurmaForm {

    @NotNull
    private Long idTurma;

}

