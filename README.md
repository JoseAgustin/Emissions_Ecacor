# Emissions_Ecacor
Set of programs to generate emissions inventory for Central México.

## Descripción

Conjunto de programas en Fortran para generar el **inventario de emisiones del centro de México** 
(zona ECACOR) en formato compatible con el modelo **WRF-Chem**.

Cubre emisiones de fuentes móviles, de área y puntuales de contaminantes criterio para la 
Zona Metropolitana del Valle de México y estados circundantes.

## Estructura del repositorio

```
Emissions_Ecacor/
├── 01_datos/       # Datos de entrada del inventario
├── README.md
└── .gitignore
```

## Requisitos

- Fortran 90/95 o superior
- Bibliotecas NetCDF
- WRF-Chem

## Uso

1. Preparar los datos de entrada en `01_datos/`
2. Compilar y ejecutar los programas en orden
3. Las salidas son archivos NetCDF para WRF-Chem

## Autor

**José Agustín García Reynoso**  
Centro de Ciencias de la Atmósfera, UNAM  
📧 agustin@atmosfera.unam.mx  
🔗 https://github.com/JoseAgustin

## Licencia

Ver archivo [LICENSE](LICENSE) para detalles.
