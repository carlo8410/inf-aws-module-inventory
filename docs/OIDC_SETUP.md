# Configuración de AWS OIDC para GitHub Actions

Este documento detalla los pasos realizados para configurar una conexión segura entre GitHub y AWS utilizando OpenID Connect (OIDC), eliminando la necesidad de usar claves de acceso de AWS permanentes.

## 1. Configuración del Repositorio
- Se inicializó el repositorio Git local.
- Se vinculó con el remoto: `git@github.com:carlo8410/inf-aws-module-inventory.git`.
- Se estableció la rama principal como `master`.

## 2. Configuración en la Consola de AWS (IAM)

### A. Crear el Proveedor de Identidad
1. Ir a **IAM** > **Identity providers** > **Add provider**.
2. Tipo: **OpenID Connect**.
3. Provider URL: `https://token.actions.githubusercontent.com`.
4. Audience: `sts.amazonaws.com`.

### B. Crear el Rol de IAM
1. Ir a **Roles** > **Create role**.
2. Tipo: **Web Identity**.
3. Seleccionar el proveedor OIDC de GitHub y la audiencia `sts.amazonaws.com`.
4. **Filtro de Seguridad**: Configurado para que solo este repositorio pueda usar el rol:
   - `repo:carlo8410/inf-aws-module-inventory:*`
5. **Permisos**: Se asignó la política `AdministratorAccess`.
6. **ARN del Rol**: Copiar el ARN generado (ej: `arn:aws:iam::123456789012:role/github-actions-oidc-role`).

## 3. Configuración en GitHub
1. Ir a los **Settings** del repositorio en GitHub.
2. Navegar a **Secrets and variables** > **Actions**.
3. Crear un **Repository secret**:
   - Nombre: `AWS_ROLE_ARN`
   - Valor: El ARN copiado de la consola de AWS.

## 4. Flujo de Trabajo (CI/CD)
El archivo `.github/workflows/terraform.yml` fue configurado con los siguientes elementos clave:

- **Permisos**:
  ```yaml
  permissions:
    id-token: write  # Requerido para solicitar el token OIDC
    contents: read   # Requerido para leer el código
  ```
- **Autenticación**:
  ```yaml
  - name: Configure AWS Credentials
    uses: aws-actions/configure-aws-credentials@v4
    with:
      role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
      aws-region: "us-east-2"
  ```

## 5. Control de Despliegue
- **Pull Requests**: Ejecutan `terraform plan` para previsualizar cambios.
- **Merge a Master**: Ejecuta `terraform apply --auto-approve` para aplicar los cambios automáticamente.

---
**Seguridad**: Gracias a esta configuración, nadie que clone o haga un fork de tu repositorio podrá acceder a tus recursos de AWS, ya que la confianza está ligada estrictamente a tu identidad y repositorio en GitHub.
