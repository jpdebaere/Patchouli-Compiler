MODULE Base;

IMPORT
	S := Scn;

CONST
	MaxExt* = 7;

	(* Type form *)
	tInt* = 0; tBool* = 1; tSet* = 2; tChar* = 3; tReal* = 4;
	tPtr* = 5; tProc* = 6; tArray* = 7; tRec* = 8; tStr* = 9; tNil* = 10;
	tStructs* = {tArray, tRec};

TYPE
	Type* = POINTER TO TypeDesc;
	Object* = POINTER TO ObjDesc;
	Node* = POINTER TO NodeDesc;
	Ident* = POINTER TO IdentDesc;
	Scope* = POINTER TO ScopeDesc;
	
	ObjDesc = RECORD type*: Type END ;
	Const* = POINTER TO RECORD (ObjDesc) value*: INTEGER END ;
	TypeObj* = POINTER TO RECORD (ObjDesc) END ;
	Var* = POINTER TO RECORD (ObjDesc) lev*: INTEGER; ronly*: BOOLEAN END ;
	Par* = POINTER TO RECORD (Var) varpar*: BOOLEAN END;
	Field* = POINTER TO RECORD (ObjDesc) END ;
	
	Proc* = POINTER TO RECORD (ObjDesc)
		lev*: INTEGER;
		decl*: Ident; statseq*: Node; return*: Object
	END;
	
	Module* = POINTER TO RECORD (ObjDesc) first*: Ident END ;

	NodeDesc = RECORD (ObjDesc)
		op*: INTEGER;
		left*, right*: Object
	END ;

	IdentDesc = RECORD
		expo*: BOOLEAN; name*: S.Ident; obj*: Object; next*: Ident
	END ;
	ScopeDesc = RECORD first*: Ident; dsc: Scope END ;

	TypeDesc = RECORD
		form*, len*: INTEGER;
		fields*: Ident; base*: Type
	END ;

VAR
	externalIdentNotFound*: Ident; guard*: Object;
	mod*: POINTER TO RECORD
		id*: S.Ident;
		curLev*: INTEGER;
		init*: Node;
		topScope*, universe*: Scope;
		intType*: Type
	END ;

PROCEDURE NewIdent*(VAR ident: Ident; name: S.Ident);
	VAR prev, x: Ident;
BEGIN
	x := mod.topScope.first; NEW(ident); ident.name := name;
	WHILE x # NIL DO
		IF x # NIL THEN S.Mark('duplicated ident') END ;
		prev := x; x := x.next
	END ;
	IF prev # NIL THEN prev.next := ident
	ELSE mod.topScope.first := ident
	END
END NewIdent;

PROCEDURE OpenScope*;
END OpenScope;

PROCEDURE CloseScope*;
END CloseScope;

PROCEDURE IncLev*(x: INTEGER);
BEGIN INC(mod.curLev, x)
END IncLev;

PROCEDURE NewConst*(t: Type; val: INTEGER): Const;
	VAR c: Const;
BEGIN NEW(c); c.type := t; c.value := val;
	RETURN c
END NewConst;

PROCEDURE NewTypeObj*(): TypeObj;
BEGIN
	RETURN NIL
END NewTypeObj;

PROCEDURE NewVar*(t: Type): Var;
BEGIN
	RETURN NIL
END NewVar;

PROCEDURE NewField*(t: Type): Field;
BEGIN
	RETURN NIL
END NewField;

PROCEDURE NewProc*(): Proc;
	VAR x: Proc;
BEGIN
	NEW(x); x.lev := mod.curLev;
	RETURN x
END NewProc;

PROCEDURE NewArray*(VAR t: Type; len: INTEGER);
END NewArray;

PROCEDURE NewRecord*(VAR t: Type);
END NewRecord;

PROCEDURE NewPointer*(VAR t: Type);
END NewPointer;

PROCEDURE NewProcType*(VAR t: Type);
END NewProcType;

PROCEDURE Init*(modid: S.Ident);
BEGIN
	NEW(mod); NEW(mod.universe); mod.id := modid;
	mod.topScope := mod.universe
END Init;

PROCEDURE SetModinit*(modinit: Node);
BEGIN mod.init := modinit
END SetModinit;

BEGIN
	NEW(guard); NEW(externalIdentNotFound);
END Base.
