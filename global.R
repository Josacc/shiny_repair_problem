# Simular un problema de reparación de máquinas y
# determinar el tiempo de colapso promedio del sistema.

# n: número de máquinas en funcionamiento.
# s: número de máquinas de repuesto.
# l: parámetro de la distribución exponencial que genera
# el tiempo de reparación de una máquina.

# Función que genera valores de una V.A. exp(l)
e <- function(l){
  x <- (-1/l) * log(runif(1))
  return(x)
}

# Función principal
f <- function(n, s, l){
  t <- 0
  r <- 0
  t_reparacion <- Inf
  X <- runif(n)
  t_I <-  sort(X)  #ordena de menor a mayor los elementos del vector x

  while (r < s + 1) {
    if(t_I[1] < t_reparacion){
      t <- t_I[1]
      r <- r + 1       # Debido al fallo de una máquina
      if(r < s + 1){
        x <- runif(1)
        t_I[1] <- t + x
        t_I <- sort(t_I)
      }
      if(r == 1){
        Y <- e(l)
        t_reparacion <- t + Y
      }
    }else{
      t <- t_reparacion
      r <- r - 1
      if(r > 0){
        Y <- e(l) #Tiempo de reparación
        t_reparacion <- t + Y # Instante en que vuelve al conjunto de las máquinas de repuesto
      }else{t_reparacion <- Inf}
    }
  }
  T_colapso <- t
  return(T_colapso)
}

# Función para obtener el valor esperado del tiempo de colapso del sistema.
g <- function(n, s, l, M){
  a <- vector()
  for (k in 1:M) {
    a[k] <- f(n, s, l)
  }
  return(mean(a))
}
