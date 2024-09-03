import { DateTime } from 'luxon'
import { BaseModel, column } from '@adonisjs/lucid/orm'

export default class User extends BaseModel {
  @column({ isPrimary: true })
  declare id: number

  @column()
  declare name: string

  @column()
  declare lastName: string

  @column()
  declare cpf: string

  @column()
  declare email: string

  @column()
  declare birthdate: DateTime

  @column.dateTime({ autoCreate: true })
  declare createdAt: DateTime

}
