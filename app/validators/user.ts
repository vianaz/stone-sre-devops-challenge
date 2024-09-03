import vine from '@vinejs/vine'

export const createUserValidator = vine.compile(
  vine.object({
    name: vine.string(),
    cpf: vine.string().fixedLength(11).regex(/^[0-9]+$/),
    email: vine.string().email(),
    lastName: vine.string(),
    birthdate: vine.date(),
  })
)
