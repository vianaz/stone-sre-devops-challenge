import factory from '@adonisjs/lucid/factories'
import User from '#models/user'
import { DateTime } from 'luxon'

export const UserFactory = factory
  .define(User, async ({ faker }) => {
    return {
      name: faker.person.firstName(),
      lastName: faker.person.lastName(),
      cpf: '12345678901',
      email: faker.internet.email(),
      birthdate: DateTime.fromJSDate(faker.date.past()),
    }
  })
  .build()
