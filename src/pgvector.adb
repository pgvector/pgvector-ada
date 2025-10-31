with Ada.Text_IO; use Ada.Text_IO;
with GNATCOLL.SQL.Exec; use GNATCOLL.SQL.Exec;
with GNATCOLL.SQL.Postgres;

procedure Pgvector is
   DB_Descr : Database_Description;
   DB : Database_Connection;
   R : Forward_Cursor;

   procedure Check (DB : Database_Connection) is
   begin
      if not Success (DB) then
         raise Program_Error with Error (DB);
      end if;
   end Check;
begin
   DB_Descr := GNATCOLL.SQL.Postgres.Setup (Database => "pgvector_ada_test");
   DB := DB_Descr.Build_Connection;

   DB.Execute ("CREATE EXTENSION IF NOT EXISTS vector");
   Check (DB);

   DB.Execute ("DROP TABLE IF EXISTS items");
   Check (DB);

   DB.Execute ("CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))");
   Check (DB);

   DB.Execute ("INSERT INTO items (embedding) VALUES ($1), ($2)", Params => (1 => +"[1,2,3]", 2 => +"[4,5,6]"));
   Check (DB);

   R.Fetch (DB, "SELECT * FROM items ORDER BY embedding <-> $1 LIMIT 5", Params => (1 => +"[3,1,2]"));
   Check (DB);
   while Has_Row (R) loop
      Put_Line (Value (R, 0) & ": " & Value (R, 1));
      Next (R);
   end loop;

   Free (DB);
   Free (DB_Descr);
end Pgvector;
