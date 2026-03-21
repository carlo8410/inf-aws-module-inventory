# Estrategia de Gestión de Aliases en Lambda

Este documento detalla las opciones consideradas para gestionar el alias `fixed` de las funciones Lambda y la justificación de la estrategia seleccionada.

## Objetivo
Permitir que el repositorio de infraestructura (`inf-aws-module-inventory`) cree los recursos base, pero que el repositorio de la aplicación (Lambda) tenga el control sobre qué versión de código se considera "estable" o "fija", sin interferencias mutuas.

---

## Opciones Consideradas

### Opción 1: Ciclo de Vida con `ignore_changes` (Sleccionada)
**Descripción:** Terraform crea el recurso `aws_lambda_alias` inicialmente, pero se le instruye para que ignore cualquier cambio manual o externo en el campo `function_version`.

```hcl
lifecycle {
  ignore_changes = [function_version]
}
```

*   **Pros:**
    *   La infraestructura centralizada sigue siendo dueña del ciclo de vida del recurso (creación/borrado).
    *   El equipo de desarrollo puede actualizar el alias libremente mediante AWS CLI o scripts personalizados durante su despliegue.
    *   Terraform no intentará revertir los cambios del alias en ejecuciones posteriores de infraestructura.
*   **Contras:** Requiere que el repositorio de aplicación tenga permisos para ejecutar comandos de actualización de alias.

### Opción 2: Gestión Total en el Repo de Aplicación
**Descripción:** El recurso `aws_lambda_alias` se elimina de este repositorio y se traslada al Terraform/CloudFormation del repositorio de la Lambda.

*   **Pros:** Separación total de responsabilidades.
*   **Contras:** Rompe la centralización de la infraestructura básica en este repositorio, que es el objetivo del proyecto `mc-inventory`.

### Opción 3: Uso de AWS SSM Parameter Store
**Descripción:** El alias lee su versión de un parámetro en SSM. El repositorio de aplicación actualiza el parámetro.

*   **Pros:** Muy estructurado.
*   **Contras:** Requiere una ejecución de `terraform apply` en este repositorio cada vez que se quiere ver reflejado el cambio del parámetro en el alias real, lo cual es ineficiente.

---

## Justificación de la Selección (Opción 1)
Se ha seleccionado la **Opción 1** porque proporciona el mejor equilibrio entre:
1.  **Centralización:** El alias es un componente de infraestructura y debe estar definido aquí.
2.  **Agilidad:** Permite al equipo de aplicación "promocionar" versiones a estable de forma instantánea sin depender de un despliegue de infraestructura.
3.  **Robustez:** Evita que cambios manuales accidentales en la consola de AWS afecten al flujo, pero permite cambios intencionados desde pipelines externos.
