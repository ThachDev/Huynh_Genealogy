abstract class BaseDataMapper<Data, Entity> {
  Entity mapToEntity(Data? data);
  Data mapToData(Entity entity);
}
