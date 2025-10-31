# pgvector-ada

[pgvector](https://github.com/pgvector/pgvector) examples for Ada

Supports [GNATcoll](https://github.com/AdaCore/gnatcoll-db)

[![Build Status](https://github.com/pgvector/pgvector-ada/actions/workflows/build.yml/badge.svg)](https://github.com/pgvector/pgvector-ada/actions)

## Getting Started

Follow the instructions for your database library:

- [GNATcoll](#gnatcoll)

## GNATcoll

Enable the extension

```ada
DB.Execute ("CREATE EXTENSION IF NOT EXISTS vector");
```

Create a table

```ada
DB.Execute ("CREATE TABLE items (id bigserial PRIMARY KEY, embedding vector(3))");
```

Insert vectors

```ada
DB.Execute ("INSERT INTO items (embedding) VALUES ($1), ($2)", Params => (1 => +"[1,2,3]", 2 => +"[4,5,6]"));
```

Get the nearest neighbors

```ada
R.Fetch (DB, "SELECT * FROM items ORDER BY embedding <-> $1 LIMIT 5", Params => (1 => +"[3,1,2]"));
while Has_Row (R) loop
   Put_Line (Value (R, 0));
   Next (R);
end loop;
```

Add an approximate index

```ada
DB.Execute ("CREATE INDEX ON items USING hnsw (embedding vector_l2_ops)");
-- or
DB.Execute ("CREATE INDEX ON items USING ivfflat (embedding vector_l2_ops) WITH (lists = 100)");
```

Use `vector_ip_ops` for inner product and `vector_cosine_ops` for cosine distance

See a [full example](src/pgvector.adb)

## Contributing

Everyone is encouraged to help improve this project. Here are a few ways you can help:

- [Report bugs](https://github.com/pgvector/pgvector-ada/issues)
- Fix bugs and [submit pull requests](https://github.com/pgvector/pgvector-ada/pulls)
- Write, clarify, or fix documentation
- Suggest or add new features

To get started with development:

```sh
git clone https://github.com/pgvector/pgvector-ada.git
cd pgvector-ada
createdb pgvector_ada_test
alr run
```
