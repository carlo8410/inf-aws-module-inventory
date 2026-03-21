# Bloqueo de Estado Nativo en S3 (Terraform 1.10+)

Este proyecto utiliza la característica de **bloqueo nativo de S3** introducida en Terraform v1.10 para gestionar la concurrencia y evitar que el estado se corrompa.

## ¿Por qué es IMPORTANTE el bloqueo?

Sin un sistema de bloqueo, tu infraestructura corre varios riesgos graves:
1. **Corrupción del Estado**: Si dos personas (o GitHub Actions) escriben en el archivo `.tfstate` al mismo tiempo, el archivo puede quedar incompleto, rompiendo la base de datos interna de Terraform.
2. **Conflictos de Recursos**: Dos procesos podrían intentar crear el mismo recurso de AWS (como una base de datos) simultáneamente, lo que genera errores de "ResourceAlreadyExists" o configuraciones duplicadas.
3. **Inconsistencias en CI/CD**: En equipos grandes, si dos Pull Requests se fusionan muy rápido, el bloqueo asegura que GitHub Actions procese una implementación completa antes de empezar la siguiente.


## Configuración Implementada
En el archivo `main.tf`, el bloque de backend está configurado así:

```hcl
terraform {
  backend "s3" {
    bucket       = "inf-aws-module-inventory-state"
    key          = "dev/terraform.tfstate"
    region       = "us-east-2"
    encrypt      = true
    use_lockfile = true  # ACTIVA EL BLOQUEO NATIVO
  }
}
```

## Ventajas de S3 Native Locking
Anteriormente, Terraform requería una tabla de **Amazon DynamoDB** adicional para gestionar los bloqueos. Con `use_lockfile = true`:
1. **Menos Recursos**: No necesitas crear ni pagar por una tabla de DynamoDB.
2. **Simplicidad**: El bloqueo se gestiona mediante un archivo de bloqueo (`.tflock`) directamente dentro del bucket de S3.
3. **Configuración Rápida**: Solo necesitas una línea de código adicional en tu backend.

## Requisitos y Buenas Prácticas
- **Terraform 1.10 o superior**: Esta función no está disponible en versiones antiguas.
- **Bucket Versioning**: Es altamente recomendable tener activado el versionado en el bucket `inf-aws-module-inventory-state` para poder recuperar estados anteriores si fuera necesario.

---
**Nota**: Si alguna vez recibes un error indicando que el estado está bloqueado y estás seguro de que nadie más está ejecutando Terraform, puedes usar el comando `terraform force-unlock <LOCK_ID>`.
