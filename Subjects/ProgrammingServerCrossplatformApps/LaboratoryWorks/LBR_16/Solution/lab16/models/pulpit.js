module.exports = (sequelize, DataTypes) => {
    const Pulpit = sequelize.define('Pulpit', {
        pulpit: { type: DataTypes.STRING, primaryKey: true },
        name: DataTypes.STRING,
        faculty: DataTypes.STRING,
    }, {
        timestamps: false,
        freezeTableName: true,  
        tableName: 'Pulpit'  
    });

    Pulpit.associate = models => {
        Pulpit.belongsTo(models.Faculty, { foreignKey: 'faculty', targetKey: 'faculty' });
        Pulpit.hasMany(models.Subject, { foreignKey: 'pulpit', sourceKey: 'pulpit' });
        Pulpit.hasMany(models.Teacher, { foreignKey: 'pulpit', sourceKey: 'pulpit' });
    };

    return Pulpit;
};
