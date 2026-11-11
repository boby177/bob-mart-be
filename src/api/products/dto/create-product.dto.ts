import { ApiProperty } from '@nestjs/swagger';

export class CreateProductDto {
  @ApiProperty({ example: 'Iphone 18' })
  name: string;

  @ApiProperty({ example: 'New smartphone with advanced features' })
  description: string;

  @ApiProperty({ example: 250000 })
  price: number;

  @ApiProperty({ example: 100 })
  stock: number;

  @ApiProperty({ example: 'category-1' })
  categoryId: string;
}
