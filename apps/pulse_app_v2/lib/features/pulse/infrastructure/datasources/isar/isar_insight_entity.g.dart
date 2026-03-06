// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_insight_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarInsightEntityCollection on Isar {
  IsarCollection<IsarInsightEntity> get isarInsightEntitys => this.collection();
}

const IsarInsightEntitySchema = CollectionSchema(
  name: r'IsarInsightEntity',
  id: -18896552274058829,
  properties: {
    r'detailsJson': PropertySchema(
      id: 0,
      name: r'detailsJson',
      type: IsarType.string,
    ),
    r'generatedAtUtcIso': PropertySchema(
      id: 1,
      name: r'generatedAtUtcIso',
      type: IsarType.string,
    ),
    r'insightId': PropertySchema(
      id: 2,
      name: r'insightId',
      type: IsarType.string,
    ),
    r'scopeEnd': PropertySchema(
      id: 3,
      name: r'scopeEnd',
      type: IsarType.string,
    ),
    r'scopeStart': PropertySchema(
      id: 4,
      name: r'scopeStart',
      type: IsarType.string,
    ),
    r'summaryText': PropertySchema(
      id: 5,
      name: r'summaryText',
      type: IsarType.string,
    )
  },
  estimateSize: _isarInsightEntityEstimateSize,
  serialize: _isarInsightEntitySerialize,
  deserialize: _isarInsightEntityDeserialize,
  deserializeProp: _isarInsightEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'insightId': IndexSchema(
      id: 5818887354909674719,
      name: r'insightId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'insightId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarInsightEntityGetId,
  getLinks: _isarInsightEntityGetLinks,
  attach: _isarInsightEntityAttach,
  version: '3.1.0+1',
);

int _isarInsightEntityEstimateSize(
  IsarInsightEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.detailsJson;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.generatedAtUtcIso.length * 3;
  bytesCount += 3 + object.insightId.length * 3;
  bytesCount += 3 + object.scopeEnd.length * 3;
  bytesCount += 3 + object.scopeStart.length * 3;
  bytesCount += 3 + object.summaryText.length * 3;
  return bytesCount;
}

void _isarInsightEntitySerialize(
  IsarInsightEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.detailsJson);
  writer.writeString(offsets[1], object.generatedAtUtcIso);
  writer.writeString(offsets[2], object.insightId);
  writer.writeString(offsets[3], object.scopeEnd);
  writer.writeString(offsets[4], object.scopeStart);
  writer.writeString(offsets[5], object.summaryText);
}

IsarInsightEntity _isarInsightEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarInsightEntity();
  object.detailsJson = reader.readStringOrNull(offsets[0]);
  object.generatedAtUtcIso = reader.readString(offsets[1]);
  object.id = id;
  object.insightId = reader.readString(offsets[2]);
  object.scopeEnd = reader.readString(offsets[3]);
  object.scopeStart = reader.readString(offsets[4]);
  object.summaryText = reader.readString(offsets[5]);
  return object;
}

P _isarInsightEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarInsightEntityGetId(IsarInsightEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarInsightEntityGetLinks(
    IsarInsightEntity object) {
  return [];
}

void _isarInsightEntityAttach(
    IsarCollection<dynamic> col, Id id, IsarInsightEntity object) {
  object.id = id;
}

extension IsarInsightEntityByIndex on IsarCollection<IsarInsightEntity> {
  Future<IsarInsightEntity?> getByInsightId(String insightId) {
    return getByIndex(r'insightId', [insightId]);
  }

  IsarInsightEntity? getByInsightIdSync(String insightId) {
    return getByIndexSync(r'insightId', [insightId]);
  }

  Future<bool> deleteByInsightId(String insightId) {
    return deleteByIndex(r'insightId', [insightId]);
  }

  bool deleteByInsightIdSync(String insightId) {
    return deleteByIndexSync(r'insightId', [insightId]);
  }

  Future<List<IsarInsightEntity?>> getAllByInsightId(
      List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'insightId', values);
  }

  List<IsarInsightEntity?> getAllByInsightIdSync(List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'insightId', values);
  }

  Future<int> deleteAllByInsightId(List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'insightId', values);
  }

  int deleteAllByInsightIdSync(List<String> insightIdValues) {
    final values = insightIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'insightId', values);
  }

  Future<Id> putByInsightId(IsarInsightEntity object) {
    return putByIndex(r'insightId', object);
  }

  Id putByInsightIdSync(IsarInsightEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'insightId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByInsightId(List<IsarInsightEntity> objects) {
    return putAllByIndex(r'insightId', objects);
  }

  List<Id> putAllByInsightIdSync(List<IsarInsightEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'insightId', objects, saveLinks: saveLinks);
  }
}

extension IsarInsightEntityQueryWhereSort
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QWhere> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarInsightEntityQueryWhere
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QWhereClause> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      insightIdEqualTo(String insightId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'insightId',
        value: [insightId],
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterWhereClause>
      insightIdNotEqualTo(String insightId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [],
              upper: [insightId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [insightId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [insightId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'insightId',
              lower: [],
              upper: [insightId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarInsightEntityQueryFilter
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QFilterCondition> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'detailsJson',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'detailsJson',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detailsJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'detailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'detailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'detailsJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'detailsJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detailsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      detailsJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'detailsJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAtUtcIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'generatedAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'generatedAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'generatedAtUtcIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'generatedAtUtcIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAtUtcIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      generatedAtUtcIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'generatedAtUtcIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'insightId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'insightId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'insightId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'insightId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      insightIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'insightId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scopeEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scopeEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scopeEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scopeEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scopeEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scopeEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scopeEnd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scopeEnd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scopeEnd',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeEndIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scopeEnd',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scopeStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scopeStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scopeStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scopeStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scopeStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scopeStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scopeStart',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scopeStart',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scopeStart',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      scopeStartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scopeStart',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summaryText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summaryText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summaryText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summaryText',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterFilterCondition>
      summaryTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summaryText',
        value: '',
      ));
    });
  }
}

extension IsarInsightEntityQueryObject
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QFilterCondition> {}

extension IsarInsightEntityQueryLinks
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QFilterCondition> {}

extension IsarInsightEntityQuerySortBy
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QSortBy> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailsJson', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailsJson', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByGeneratedAtUtcIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtUtcIso', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByGeneratedAtUtcIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtUtcIso', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByInsightId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByInsightIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByScopeEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeEnd', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByScopeEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeEnd', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByScopeStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeStart', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortByScopeStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeStart', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortBySummaryText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      sortBySummaryTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.desc);
    });
  }
}

extension IsarInsightEntityQuerySortThenBy
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QSortThenBy> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByDetailsJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailsJson', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByDetailsJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detailsJson', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByGeneratedAtUtcIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtUtcIso', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByGeneratedAtUtcIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAtUtcIso', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByInsightId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByInsightIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'insightId', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByScopeEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeEnd', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByScopeEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeEnd', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByScopeStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeStart', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenByScopeStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scopeStart', Sort.desc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenBySummaryText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.asc);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QAfterSortBy>
      thenBySummaryTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summaryText', Sort.desc);
    });
  }
}

extension IsarInsightEntityQueryWhereDistinct
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct> {
  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByDetailsJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detailsJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByGeneratedAtUtcIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAtUtcIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByInsightId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'insightId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByScopeEnd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scopeEnd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctByScopeStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scopeStart', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarInsightEntity, IsarInsightEntity, QDistinct>
      distinctBySummaryText({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summaryText', caseSensitive: caseSensitive);
    });
  }
}

extension IsarInsightEntityQueryProperty
    on QueryBuilder<IsarInsightEntity, IsarInsightEntity, QQueryProperty> {
  QueryBuilder<IsarInsightEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarInsightEntity, String?, QQueryOperations>
      detailsJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detailsJson');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      generatedAtUtcIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAtUtcIso');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      insightIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'insightId');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations> scopeEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scopeEnd');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      scopeStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scopeStart');
    });
  }

  QueryBuilder<IsarInsightEntity, String, QQueryOperations>
      summaryTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summaryText');
    });
  }
}
