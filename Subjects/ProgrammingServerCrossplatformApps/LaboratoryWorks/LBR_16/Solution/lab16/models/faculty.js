module.exports = (sequelize, DataTypes) => {
    const Faculty = sequelize.define('Faculty', {
        faculty: { type: DataTypes.STRING, primaryKey: true },
        name: DataTypes.STRING,
    }, {
        timestamps: false,
        freezeTableName: true, 
        tableName: 'Faculty'  
    });

    Faculty.associate = models => {
        Faculty.hasMany(models.Pulpit, { foreignKey: 'faculty', sourceKey: 'faculty' });
    };

    return Faculty;
};
