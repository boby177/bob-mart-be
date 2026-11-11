export const FIND_ALL_PRODUCTS = `
  MATCH (p:Product)
  RETURN p { .*, createdAt: toString(p.createdAt) } AS product
  ORDER BY p.createdAt DESC
`;

export const FIND_PRODUCT_BY_ID = `
  MATCH (p:Product { id: $id })
    RETURN p { .*, createdAt: toString(p.createdAt) } AS product
`;

export const CREATE_PRODUCT = `
MATCH (c:Category {id: $categoryId})
CREATE (p:Product {
id: $id,
name: $name,
description: $description,
price: $price,
stock: $stock,
createdAt: datetime()
})

Create (p)-[:IN_CATEGORY]->(c)
    RETURN p { .*, createdAt: toString(p.createdAt) } AS newProduct
`;

export const UPDATE_PRODUCT = `
MATCH (p:Product {id: $id})
SET p += $data,
    p.updatedAt = datetime()
RETURN p { .*, createdAt: toString(p.createdAt), updatedAt: toString(p.updatedAt) } AS product
`;

export const DELETE_PRODUCT = `
MATCH (p:Product {id: $id})
DETACH DELETE p
`;
