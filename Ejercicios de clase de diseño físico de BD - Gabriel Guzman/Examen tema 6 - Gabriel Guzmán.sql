-- EXAMEN BD TEMA 6.- PROGRAMACIÓN DE BASES DE DATOS

-- 1º CURSO DAM

USE jardineria;

-- 1) PROCEDIMIENTOS Y FUNCIONES

-- Crea un procedimiento almacenado llamado mostrarPedidos que reciba como parámetro el codigo de pedido que se desea mostrar. 
-- Se debe mostrar el pedido y los productos que conforman el pedido. Por tanto, los campos a mostrar serán: codigoPedido, FechaPedido, CodigoCliente, NumeroLinea, CodigoProducto, Cantidad, PrecioUnidad, Importe.

-- El importe será un campo calculado (precioUnidad * cantidad).
-- Los pedidos se mostrarán ordenados ascendentemente por los campos codigoPedido y NumeroLinea.


DROP PROCEDURE IF EXISTS mostrarPedidos;

DELIMITER $$
CREATE PROCEDURE mostrarPedidos(IN v_codigo_pedido int)
BEGIN
   select   p.codigo_pedido, p.fecha_pedido ,p.codigo_cliente
	from pedido p
	where p.codigo_pedido = v_codigo_pedido;
    
	select  d.codigo_producto,  d.cantidad, d.precio_unidad
	from detalle_pedido d
	where d.codigo_pedido = v_codigo_pedido;
END$$
DELIMITER ;

call mostrarPedidos (1);

-- 2) TRIGGERS

-- Crea un trigger llamado alarma_stock. Dicho trigger almacenará en una tabla, llamada existencias_cero, aquellos productos cuyo stock esté a cero.
-- La tabla debe contener los siguientes campos: códigoProducto y fecha.
-- El campo fecha almacenará la fecha en la que el stock del producto llegó a cero.

    -- Primero creamos la tabla de auditoría
CREATE TABLE existencias_cero (
    codigo_producto varchar(15),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP trigger IF EXISTS alarma_stock;

DELIMITER $$
CREATE TRIGGER alarma_stock
before update on producto
for each row
begin
	if stock <= 0 then
		INSERT INTO existencias_cero (codigo_producto)
		VALUES (codigo_producto);
    end if;
end$$
DELIMITER ;

UPDATE producto SET cantidad_en_stock = 0 WHERE nombre = 'Pala'; 

select * from existencias_cero;

 
 -- 3) EVENTOS O VISTAS
 
-- Crea una vista llamada pedidosNoEntregados que muestre los pedidos que no han sido entregados. 
-- La vista debe contener los siguientes campos: CodigoPedido, FechaPedido, FechaEsperada y Estado. 
-- Configura la vista para que cuando ésta se actualice siga cumpliendo las condiciones que se incluyeron en su definición.
-- Intenta insertar un pedido que no ha sido entregado utilizando dicha vista. ¿Es esta vista actualizable? Razona la respuesta.  
