-- D�finition d'une exception commune � toutes les SDA.
package SDA_Exceptions is

	Cle_Absente_Exception  : Exception;	-- une cl� est absente d'un SDA
	LCA_vide : Exception; --la lca est vide;
end SDA_Exceptions;
