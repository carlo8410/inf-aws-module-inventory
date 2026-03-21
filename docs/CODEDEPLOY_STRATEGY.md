# Análisis: Estrategia de Despliegue con AWS CodeDeploy

Este documento analiza cómo integrar la **Estrategia 1 (Ignore Changes)** de Aliases de Lambda con **AWS CodeDeploy** para lograr despliegues automáticos, seguros y con rollback.

## 1. El Rol de CodeDeploy
AWS CodeDeploy es el servicio de Amazon diseñado para gestionar la transición de tráfico entre versiones de Lambda de forma controlada (Canary, Linear o All-at-once).

### Cómo encaja con nuestra Estrategia 1
Nuestra estrategia de `ignore_changes` en el alias `fixed` es **perfecta** para CodeDeploy porque:
*   Terraform crea el alias una sola vez.
*   CodeDeploy "secuestra" ese alias para mover el tráfico hacia la nueva versión.
*   Terraform no interfiere ni intenta revertir el movimiento de tráfico que haga CodeDeploy.

---

## 2. Flujo de Trabajo Recomendado

### Fase A: Infraestructura (Este Repositorio)
Debemos preparar el terreno para CodeDeploy:
1.  **CodeDeploy Application:** Un recurso lógico para agrupar los despliegues.
2.  **Deployment Group:** Define *cómo* se despliega (ej: `LambdaCanary10Percent5Minutes`).
3.  **IAM Role:** Permisos para que CodeDeploy pueda actualizar los alias de la Lambda.

### Fase B: Aplicación (Repositorio de la Lambda)
El pipeline de la Lambda ya no usa el comando `update-alias` directamente, sino que:
1.  Publica la nueva **Versión X**.
2.  Genera un archivo `appspec.yml` (ver ejemplo abajo).
3.  Crea un **Deployment** en CodeDeploy.

```yaml
# apsec.yml (en el repo de la Lambda)
version: 0.0
Resources:
  - myLambdaFunction:
      Type: AWS::Lambda::Function
      Properties:
        Name: "mc-register-product-lambda"
        Alias: "fixed"
        CurrentVersion: "1" # Versión actual
        TargetVersion: "2"  # Nueva versión
```

---

## 3. Ventajas de esta Integración

*   **Despliegues Progresivos (Canary):** Puedes enviar solo el 10% del tráfico a la nueva versión y esperar 5 minutos. Si hay errores (CloudWatch Alarms), CodeDeploy hace **Rollback automático** al alias.
*   **Validaciones Automatizadas:** Puedes ejecutar una Lambda de "PreTraffic" para correr tests de integración antes de que el primer usuario vea el código nuevo.
*   **Separación de Responsabilidades:**
    *   **Infra:** Define el alias y la política de despliegue.
    *   **App:** Define el momento del despliegue y el código.

---

## 4. Conclusión
La **Estrategia 1** es la base necesaria para usar CodeDeploy. Al ignorar los cambios del alias en Terraform, permites que CodeDeploy sea el orquestador real del tráfico en tiempo de ejecución, manteniendo la infraestructura declarativa para todo lo demás.
